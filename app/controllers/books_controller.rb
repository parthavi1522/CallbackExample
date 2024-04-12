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
