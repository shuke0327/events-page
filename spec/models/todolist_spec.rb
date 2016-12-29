require 'rails_helper'

RSpec.describe Todolist, type: :model do
  it "is invalid without name" do
    new_todolist = Todolist.new(name:'')
    expect(new_todolist).not_to be_valid
    expect(new_todolist.errors[:name]).to include "can't be blank"
  end
end
