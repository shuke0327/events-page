require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'is valid with name' do
    team = Team.new(name: "new Team")
    expect(team).to be_valid
  end

  it 'is invalid without name' do
    team = Team.new(name:nil)
    expect(team).not_to be_valid
  end
end
