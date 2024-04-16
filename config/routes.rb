Rails.application.routes.draw do
  get 'backup_books/index'
  resources :books
  resources :backup_books, only: [:index]
  root 'home#index'
end
