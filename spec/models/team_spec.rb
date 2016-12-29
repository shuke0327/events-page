require 'rails_helper'

RSpec.describe Team, type: :model do
  before :each do
    @team = Team.create(name: 'New Team')
  end 

  it 'is valid with name' do
    @team.name="changed teams"
    expect(@team).to be_valid
  end

  it 'is invalid without name' do
    @team.name = nil
    expect(@team).not_to be_valid
  end
end
