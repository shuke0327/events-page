FactoryGirl.define do
  factory :user do
    name "example_user"
    sequence(:email) {|n| "example-#{n}@example.org"}
    password "password"
    password_confirmation "password"
  end
end
