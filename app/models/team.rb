class Team < ApplicationRecord
  has_many :members, class_name: "User"
  has_many :projects
end
