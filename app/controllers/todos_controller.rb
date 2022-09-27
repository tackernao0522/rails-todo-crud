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
    @update_todo = Todo.find(params[:id])

    @update_todo.comment = "完了"

    respond_to do |format|
      if @update_todo.save
        format.html {redirect_to request.referer}
      else
        format.html {redirect_to request.referer}
      end
    end
  end

  def delete
    @delete_todo = Todo.find(params[:id])

    respond_to do |format|
      if @delete_todo.destroy
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
