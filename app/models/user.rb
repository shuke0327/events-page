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
end
