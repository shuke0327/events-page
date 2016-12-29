class Todolist < ApplicationRecord
  validates :name, presence: true
end
