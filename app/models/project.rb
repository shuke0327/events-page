class Project < ApplicationRecord
  belongs_to :team
  has_many :accesses
  has_many :users, through: :accesses
  validates :team_id, presence: true
end
