Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
end
