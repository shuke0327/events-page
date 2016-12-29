require 'rails_helper'

  describe Project do
  team = Team.create(name:"fake_team")
  it "is valid with a name and team_id" do
    project = Project.new(name: "hello", team_id: team.id)
  end

  it "is invalid without name" do
    project = Project.new(name:nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a team_id" do
    project = Project.new(name:"test Project")
    project.valid?
    expect(project.errors[:team_id]).to include("can't be blank")
  end
end

