class BackupBooksController < ApplicationController
  def index
    @backup_books = BackupBook.all
  end
end
