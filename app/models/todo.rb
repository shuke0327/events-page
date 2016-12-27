class Todo < ApplicationRecord
   include Wisper.model

  def create
  end

  def soft_destroy
  end

  def redo
  end

  def complete
  end

  def reopen
  end

  def assigned_to(user)
  end

  def set_due_at(time)
  end

  def comment
  end

end
