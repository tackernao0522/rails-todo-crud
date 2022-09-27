Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
  post '/todo/create', to: "todos#create", as: "create"
  patch '/todo/update', to: "todos#update", as: "update"
  delete '/todo/delete', to: "todos#delete", as: "delete"
end
