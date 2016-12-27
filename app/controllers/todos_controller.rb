class TodosController < ApplicationController
  def new
    @todo = Todo.new
  end

  def create
    @todo.update_attributes(:todo_params)
  end

  def change_assign_state
    @todo.change_assign
  end

  def change_due_at
    @todo.change_due_at
  end

  def drop
    #softdestroy
  end

  def recover
  end

  def finished
    @todo.finished
  end

  def reopen
    @todo.reopen
  end


end
