class TodosController < ApplicationController
  def index
    @todo_items = Todo.all
    @new_todo = Todo.new
  end
