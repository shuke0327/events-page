class Team < ApplicationRecord
  has_many :projects
  has_many :todos, through: :projects
  has_many :memberships
  has_many :users, through: :memberships
  validates :name, presence: true
  
end
