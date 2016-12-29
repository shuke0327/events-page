require 'rails_helper'

RSpec.describe Event, type: :model do
  
  describe "attribute test" do
    before :each do
      @project = create(:project)
      @user = create(:user)
      @todo = Todo.new(content:"test todos", creator: @user, project: @project)
      
      @event = Event.create(actor: @user, ancestor: @project,
                           invoke_item: @todo, action_desc: Event::DESC_TODO_ADD,
                           action_label: Event::LABEL_TODO_ADD)
    end

    it "is valid with all attributes" do
      expect(@event).to be_valid
    end

    it "is invalid without actor" do
      @event.actor = nil
      @event.valid?
      expect(@event.errors[:actor]).to include("must exist")
    end
    it "is invalid without ancestor_id" do
      @event.ancestor_id = nil
      @event.valid?
      expect(@event.errors[:ancestor]).to include("must exist")
    end

    it "is invalid without ancestor_type" do
      @event.ancestor_type = nil
      @event.valid?
      expect(@event.errors[:ancestor]).to include("must exist")
    end

    it "is invalid without action description" do
      @event.action_desc = nil
      @event.valid?
      expect(@event.errors[:action_desc]).to include("can't be blank")
    end

    it "is invalid without action label" do
      @event.action_label = nil
      @event.valid?
      expect(@event.errors[:action_label]).to include("can't be blank")
    end

    it "is invalid without invoke_item_type" do
      @event.invoke_item_type = nil
      @event.valid?
      expect(@event.errors[:invoke_item]).to include("must exist")
    end

    it "is invalid without invoke_item_id" do
      @event.invoke_item_id = nil
      @event.valid?
      expect(@event.errors[:invoke_item]).to include("must exist")
    end

  end


end
