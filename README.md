# README

ruby - 3.2.3
rails - 7.1.3

1. rails new callback_example --database=mysql

2. cd callback_example

3. rails generate model Book title:string author:string

4. rails db:create
   rails db:migrate

5. app/modela/book.rb
  class Book < ApplicationRecord
    validates :title, presence: true

    after_initialize :set_defaults
    after_find :output_after_find

    before_validation :normalize_title, if: :title_changed?
    after_validation :print_validation_message

    after_commit :after_commit_callback, on: [:create, :update]

    before_save :print_save_message
    before_save :check_author_presence, unless: Proc.new { |book| book.author.present? }
    around_save :print_around_save_message
    after_save :print_saved_message

    before_create :print_create_message
    around_create :print_around_create_message
    after_create :print_created_message

    before_update :print_update_message
    around_update :print_around_update_message
    after_update :print_updated_message

    before_destroy :print_destroy_message
    around_destroy :print_around_destroy_message
    after_destroy :print_destroyed_message

    after_touch :notify_title_touched
    after_touch :notify_author_touched

    private

    def set_defaults
      puts "=============="
      puts "Book initialized with title: #{title}, author: #{author}"
    end

    def output_after_find
      puts "=============="
      puts "Book found with title: #{title}, author: #{author}"
    end

    def normalize_title
      self.title = title.capitalize if title.present?
    end

    def print_validation_message
      errors.add(:base, "Title can't be blank. Please add Title") if title.blank?
    end

    def print_save_message
      puts "=============="
      puts 'Book is being saved...'
    end

    def print_around_save_message
      yield
      puts "=============="
      puts 'Book saved successfully!'
    end

    def print_saved_message
      puts "=============="
      puts 'Book saved!'
    end

    def print_create_message
      puts "=============="
      puts 'Creating book...'
    end

    def print_around_create_message
      yield
      puts "=============="
      puts 'Book created!'
    end

    def print_created_message
      puts "=============="
      puts 'Book created!!'
    end

    def print_update_message
      puts "=============="
      puts 'Updating book...'
    end

    def print_around_update_message
      yield
      puts "=============="
      puts 'Book updated!'
    end

    def print_updated_message
      puts "=============="
      puts 'Book updated!!'
    end

    def print_destroy_message
      puts "=============="
      puts 'Destroying book...'
    end

    def print_around_destroy_message
      yield
      puts "=============="
      puts 'Book destroyed!'
    end

    def print_destroyed_message
      puts "=============="
      puts 'Book destroyed!!'
    end

    def notify_title_touched
      puts "=============="
      puts "Title '#{title}' has been touched."
    end
    
    def notify_author_touched
      puts "=============="
      puts "Author '#{author}' has been touched."
    end

    def check_author_presence
      self.author = "Unknown" unless self.author.present?
    end

    def after_commit_callback
      puts "=============="
      puts "Book '#{self.title}' by #{self.author} was committed successfully."
    end
  end

6. app/controllers/books_controller.rb
  class BooksController < ApplicationController
    before_action :set_book, except: [:index, :new, :create]

    def index
      @books = Book.all
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)
      if @book.save
        @book.touch
        redirect_to book_path(@book), notice: 'Book was successfully created.'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @book.update(book_params)
        @book.touch
        redirect_to book_path(@book), notice: 'Book was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      redirect_to books_path, notice: 'Book was successfully destroyed.'
    end


    private

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author)
    end
  end

7. app/views/books/index.html.erb
<h1>Listing Books</h1>

<%= link_to 'New Book', new_book_path %>

</br>
</br>

<% if @books.present? %>
  <table class="table">
    <thead>
      <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Author</th>
        <th></th>
      </tr>
    </thead>

    <tbody>
      <% @books.each do |book| %>
        <tr>
          <td><%= book.id %></td>
          <td><%= book.title %></td>
          <td><%= book.author %></td>
          <td>
            <a href="<%= book_path(book) %>">Details</a> |
            <a href="<%= edit_book_path(book) %>">Edit</a> |
            <a href="<%= book_path(book) %>" data-turbo-method="delete" data-turbo-confirm="Are you sure?">Delete</a>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>
<% end %>

8. app/views/books/new.html.erb
  <h1>New Book</h1>

  <%= render 'form', book: @book %>

  </br>

  <%= link_to 'Back To List', books_path %>

9. app/views/books/edit.html.erb
 <h1>Edit Book</h1>

  <%= render 'form', book: @book %>

  <br/>
  <a href="<%= book_path(@book) %>">Show</a>
  |
  <a href="<%= books_path %>">Back To List</a>

10. app/views/books/_form.html.erb
  <%= form_with(model: book, local: true, data: { turbo: false }) do |form| %>
    <% if book.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(book.errors.count, "error") %> prohibited this book from being saved:</h2>

        <ul>
          <% book.errors.full_messages.each do |message| %>
            <li><%= message %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <div class="field">
      <%= form.label :title %>
      <%= form.text_field :title %>
    </div>

    </br>

    <div class="field">
      <%= form.label :author %>
      <%= form.text_field :author %>
    </div>

    </br>

    <div class="actions">
      <%= form.submit %>
    </div>
  <% end %>

11. app/views/books/ahow.html.erb
  <h1><%= @book.title %> Book</h1>
  <p><%= "#{@book.title} by #{@book.author}" %></p>

  <%= link_to 'Edit', edit_book_path(@book) %> |
  <%= link_to 'Back', books_path %>

12. config/routes.rb
  Rails.application.routes.draw do
    resources :books
    root 'books#index'
  end

13. rails s