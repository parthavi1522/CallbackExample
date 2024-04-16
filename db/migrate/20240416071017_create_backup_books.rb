class CreateBackupBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :backup_books do |t|
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
