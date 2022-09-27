# 設計

+ [参考](https://qiita.com/hito_taro/items/4915ac9004046e26f23d) <br>

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

## Read処理の実装

### Modelの作成

+ `$ rails g model todo title:string comment:string limit:date`を実行<br>

+ `$ rails db:migrate`を実行<br>

### ダミーデータの作成

+ `db/seeds.rb`を編集<br>

```rb:seeds.rb
titles = %w(test1 test2 test3 test4 test5)
0.upto(4) do |idx|
  Todo.create(
    title: titles[idx],
    comment: "test-#{titles[idx]}",
    limit: "2022-12-24"
  )
end
```

+ `$ rails db:seed`を実行<br>

## DBからデータを取得する

+ `app/controllers/todos_controller.rb`を編集<br>

```rb:todos_controller.rb
class TodosController < ApplicationController

  def index
    @todos = Todo.all() # 追加
  end
end
```

## index.html.erbに取得したデータを表示させる

```app/views/todos/index.html.erb
<h1>TOPページ</h1>

<% @todos.each do |todo| %>
<ul>
  <li><%= todo.title %></li>
  <li><%= todo.comment %></li>
  <li><%= todo.limit %></li>
</ul>

<h1>----------</h1>
<% end %>
```

## 04. Crate処理の実装

### Create用ルートの編集

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
  post '/todo/create', to: "todos#create", as: "create" # 追加
end
```

```
create  POST   /todo/create(.:format)    todos#create
```

+ `app/controllers/todos_controller.rb`を編集<br>

```rb:todos_controller.rb
class TodosController < ApplicationController

  def index
    @todos = Todo.all()

    # Viewのformで使う空のTodoインスタンスを作成します。
    # Viewはこのインスタンスにユーザから入力された値を入れてControllerに渡します。
    @new_todo = Todo.new # 追加
  end

  def create
    # 追加
  　# Viewからの入力を受け取りインスタンスを作成します。
    @todo = Todo.new(todo_params)

    # DBに値を追加した時の結果によるアクションを返します。
    # 今回は成功しても失敗しても画面を更新するだけです。
    respond_to do |format|
      if @todo.save
        format.html {redirect_to request.referer}
      else
        format.html {redirect_to request.referer}
      end
    end
  end

  private

  # StrongParameterと言ってセキュリティに関係するメソッド
  # todoモデル(:todo)で入力を許可するカラムを記載する。これ以外のデータは受付けないようになる。
  def todo_params
    params.require(:todo).permit(:title, :comment, :limit)
  end
  # ここまで
end
```

+ `app/views/todos/index.html.erb`を編集<br>

```html:index.html.erb
<h1>TOPページ</h1>

<!-- todos_controller.rbで定義した空のインスタンスに値を格納しcreate_pathにPOSTします。 -->
<%= form_with model: @new_todo, url: create_path do |form| %>
<%= form.label :title %>
<%= form.text_field :title %>

<%= form.label :comment %>
<%= form.text_field :comment %>

<%= form.label :limit %>
<%= form.date_field :limit %>

<%= form.submit %>
<% end %>

<% @todos.each do |todo| %>
<ul>
  <li><%= todo.title %></li>
  <li><%= todo.comment %></li>
  <li><%= todo.limit %></li>
</ul>

<h1>----------</h1>
<% end %>
```

+ http://localhost:3000/todo にアクセスしてテストしてみる <br>

## 06. Updateの実装

### Update用ルートの編集

+ `config/routes.rb`を編集<br>

```rb:routes.rb
Rails.application.routes.draw do
  get '/todo', to: "todos#index", as: "top"
  post '/todo/create', to: "todos#create", as: "create"
  patch '/todo/update', to: "todos#update", as: "update" # 追加
end
```

```
update PATCH  /todo/update(.:format)  todos#update
```

## Controllerでupdateメソッドを作成

+ `app/controllers/todos_controller.rb`を編集<br>

```rb:todos_controller.rb
class TodosController < ApplicationController

  def index
    @todos = Todo.all()

    @new_todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html {redirect_to request.referer}
      else
        format.html {redirect_to request.referer}
      end
    end
  end

  def update
    # todosテーブルから受け取ったIDと一致するインスタンス(行)を取得
    @update_todo = Todo.find_by(params[:id])

    # 取得したインスタンスのcomment(取得した行のcommentカラム)に"完了"を格納
    @update_todo.comment = "完了"

    # 実行した時の処理を記載(createと同じ)
    respond_to do |format|
      if @todo.save
        format.html {redirect_to request.referer}
      else
        format.html {redirect_to request.referer}
      end
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :comment, :limit)
  end
end
```

## Update用にViewを編集

+ `app/views/todos/index.html.erb`を編集

```html:index.html.erb
<h1>TOPページ</h1>

<%= form_with model: @new_todo, url: create_path do |form| %>
<%= form.label :title %>
<%= form.text_field :title %>

<%= form.label :comment %>
<%= form.text_field :comment %>

<%= form.label :limit %>
<%= form.date_field :limit %>

<%= form.submit %>
<% end %>

<% @todos.each do |todo| %>
<ul>
  <li>id<%= todo.id %>のデータ</li>
  <li><%= todo.title %></li>
  <li><%= todo.comment %></li>
  <li><%= todo.limit %></li>

   <!-- 追加 -->
   <!-- 以下の1行を追加してリンクを表示 -->
  <%= link_to "更新", update_path(id: todo.id), method: :patch %>
</ul>

<h1>----------</h1>
<% end %>
```