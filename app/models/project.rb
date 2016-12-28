class Project < ApplicationRecord
  belongs_to :team
  has_many :accesses
  has_many :users, through: :accesses
  has_many :events, as: :ancestor
  has_many :todos
  validates :team_id, presence: true

end
