Rails.application.routes.draw do
  root 'static_pages#home'

  # get 'users/new' ※rails g controller Users newで自動生成されたもの、下記に書き換え
  get '/signup', to: 'users#new'
end
