class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.string :title
      t.string :comment
      t.date :limit

      t.timestamps
    end
  end
end
