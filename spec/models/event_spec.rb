require 'rails_helper'

RSpec.describe Event, type: :model do
  
  it "is valid with a firstname, lastname and email" do
  end
  it "is invalid without a firstname"
  it "is invalid without a lastname"
  it "is invalid without an email address"
  it "is invalid with a duplicate email address"
  it "returns a contact's full name as a string"
end
