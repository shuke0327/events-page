class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :accesses
  has_many :projects, through: :accesses
  has_many :comments
  has_many :assigned_todos, class_name: "Todo", foreign_key: "assignee_id"
  has_many :created_todos, class_name: "Todo", foreign_key: "creator_id"
  has_many :completed_todos, class_name: "Todo", foreign_key: "completor_id"
  has_many :memberships
  has_many :teams, through: :memberships
  has_many :events, foreign_key: "actor_id"
  validates :name, presence: true

  def set_access_to_project!(project)
    self.projects << project
  end

  def can_access_project?(project)
    self.projects.include? project
  end

  def set_team!(team)
    self.teams << team
  end

  def accessable_projects_in(team)
    projects.where(team_id: team.id)
  end

  # TODO: need to be reafactor later!!!
  def default_team
    if teams.present?
      teams.first
    else
      team = Team.create(name: "Demo Team")
      set_team!(team)
      return team
    end
  end

end
