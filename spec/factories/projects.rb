FactoryGirl.define do
  factory :project do
    name "Project Demo"
    description "this is a demo project"
    association :team
  end
end
