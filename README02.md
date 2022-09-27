# 設計

#### 今回やるTodoアプリで実装するCRUDの処理は以下の通り

+ `Create` : Todoを作成する処理<br>

+ `Read` : Todoを表示する処理<br>

+ `Update` : Todo内容を変更する処理<br>

+ `Delete` : Todoを削除（完了）する処理<br>

#### それぞれDBを操作するSQL文に置き換えると下記のようになる

+ `C` : Todoの作成 => INSERT文<br>

+ `R` : Todoの表示 => SELECT文<br>

+ `U` : Todo内脳の変更 => UPDATE文<br>

+ `D` : Todoの削除 => DELETE文<br>

## Viewの作成

### index.html.erbの作成

+ `$ rails g controller todos`を実行<br>

+ `$ touch app/views/todos/index.html.erb`を実行<br>

+ `app/views/todos/index.html.erb`を編集<br>

```html:index.html.erb
<h1>TOPページ</h1>
```

+ `app/controllers/todos_controller.rb`を編集<br>

```rb:todos_controller.rb
class TodosController < ApplicationController

  def index

  end
end
```

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
end
```

```
Prefix Verb   URI Pattern          Controller#Action
top    GET    /todo(.:format)      todos#index
```