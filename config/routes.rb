Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
  post '/todo', to: "todos#create", as: "create"
end
