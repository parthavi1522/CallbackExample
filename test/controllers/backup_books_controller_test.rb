require "test_helper"

class BackupBooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get backup_books_index_url
    assert_response :success
  end
end
