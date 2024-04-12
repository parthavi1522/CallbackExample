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
