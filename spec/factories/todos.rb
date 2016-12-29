FactoryGirl.define do
  factory :todo do
    content "Test Todo"
    creator :user
    project :project
  end
end
