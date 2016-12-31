# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
main_user = User.create!(name:  "Example User",
             email: "example_user@tower.im",
             password:              "foobar123",
             password_confirmation: "foobar123")

team = Team.create!(name: "Test Team")
main_user.set_team!(team)

project = team.projects.create!(name: "Test Project")
main_user.set_access_to_project!(project)

10.times do |n|
  name  = Faker::Name.last_name
  email = "example-#{n+1}@tower.im"
  password = "password"
  fake_user = User.create!(name: name,
               email: email,
               password:              password,
               password_confirmation: password)
  fake_user.set_team!(team)
end

users = User.order("created_at DESC").take(6)
users.each { |user| user.set_access_to_project!(project) unless user.can_access_project?(project) }
# create todos
10.times do
  content = Faker::Lorem.word
  users.each { |user| user.created_todos.create!(content: content, project: project) }
end

# comment todos
todos = Todo.order(:created_at).take(10)
todos.each do |todo|
  content = Faker::Lorem.sentence(5)
  todo.create_comment(content, users.first)
  todo.create_comment(content, users.last)
end