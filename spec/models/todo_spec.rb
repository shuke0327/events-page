require 'rails_helper'

RSpec.describe Todo, type: :model do

  
  describe "attributes test" do

    before :each do
      @project = create(:project)
      @user = create(:user)
      @todo = Todo.create(content: Faker::Lorem.word, creator:@user, project: @project)
    end
    it "is valid with content, project_id, and creator_id" do
      expect(@todo).to be_valid
    end

    it "is invalid without a content" do
      @todo.content = nil
      @todo.valid?
      expect(@todo.errors[:content]).to include("can't be blank")
    end

    it "is invalid without a project_id" do
      @todo.project_id = nil
      @todo.valid?
      expect(@todo.errors[:project_id]).to include("can't be blank")
    end

    it "is invalid without a creator_id" do
      @todo.creator_id = nil
      @todo.valid?
      expect(@todo.errors[:creator_id]).to include("can't be blank")
    end
  end

  describe "when create todo" do
    it "should create todo-add event" do
      @project = create(:project)
      @user = create(:user)
      expect {
        @todo = Todo.create(content: Faker::Lorem.word,
                creator:@user, project: @project)}.to change(Event, :count).by(1)
      @event = Event.first # Event is order_by: created_at DESC
      expect(@event.ancestor).to eql @project
      expect(@event.invoke_item).to eql @todo
      expect(@event.actor).to eql @todo.creator
      expect(@event.action_desc).to eql Event::DESC_TODO_ADD
      expect(@event.action_label).to eql Event::LABEL_TODO_ADD
      expect(@event.action_type).to eql "common"
      end
    end
  end
  
  describe "when todo state changed" do
    before :each do
      @project = create(:project)
      @user = create(:user)
      @todo = Todo.create(content: Faker::Lorem.word,
                creator:@user, project: @project)
    end

    context "when soft destroy todo" do
      it "should create todo-del event" do
        @another_user = create(:user)
        expect {
          @todo.soft_deleted_by(@another_user)
        }.to change(Event, :count).by(1)

        expect(@todo.soft_deleted?).to eql true

        @event = Event.first
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @another_user
        expect(@event.action_desc).to eql Event::DESC_TODO_DEL
        expect(@event.action_label).to eql Event::LABEL_TODO_DEL
        expect(@event.action_type).to eql "common"
      end
    end

    context "when completed_by user" do
      it "should create todo-complete event" do
        @another_user = create(:user)
        expect {
          @todo.completed_by(@another_user)
        }.to change(Event, :count).by(1)

        expect(@todo.completed?).to eql true
        expect(@todo.completor_id).to eql @another_user.id

        @event = Event.first
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @another_user
        expect(@event.action_desc).to eql Event::DESC_TODO_COMPLETED
        expect(@event.action_label).to eql Event::LABEL_TODO_COMPLETED
        expect(@event.action_type).to eql "common"
      end
    end


    context "when assigned by current user to another_user" do
      it "should create todo-assign  event" do
        @new_assignee = create(:user)
        old_assignee_id = @todo.assignee_id

        expect {
          @todo.assigned_to(actor = @user, assignee = @new_assignee)
        }.to change(Event, :count).by(1)
        expect(@todo.assignee_id).to eql @new_assignee.id

        @event = Event.first
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @user
        expect(@event.action_desc).to include @new_assignee.name
        expect(@event.action_label).to eql Event::LABEL_TODO_ASSIGN
        expect(@event.action_type).to eql "common"
        expect(@event.old_assignee_id).to eql old_assignee_id
        expect(@event.new_assignee_id).to eql @new_assignee.id
      end
    end

    context "when reopened by user" do
      it "should create todo-reopen event" do
        @todo.completed_by @user
        @another_user = create(:user)
        expect {
          @todo.reopened_by(@another_user)}.to change(Event, :count).by(1)

        expect(@todo.completed?).to eql false
        expect(@todo.completor_id).to eql nil

        @event = Event.first
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @another_user
        expect(@event.action_desc).to eql Event::DESC_TODO_REOPEN
        expect(@event.action_label).to eql Event::LABEL_TODO_REOPEN
        expect(@event.action_type).to eql "common"
      end
    end

    context "when set due at time" do
      it "should create todo-set-due_at event" do
        expect(@todo.due_at).to eql nil # default due_at is nil
        new_time = Time.zone.now + 2.days
        expect {
          @todo.set_due_at(@user, new_time)}.to change(Event, :count).by(1)
        
        expect(@todo.due_at).to eql new_time

        @event = Event.first
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @user
        expect(@event.action_label).to eql Event::LABEL_TODO_DUE_AT_CHANGED
        expect(@event.action_type).to eql "common"
      end
    end

    context "when create todo comment" do
      it "should create todo-comment-add event" do
        old_comment_amount = @todo.comments.count
        expect {
          @todo.create_comment(content = "Test comment",
          actor = @user)}.to change(Event, :count).by(1)
        expect(@todo.comments.count - old_comment_amount).to eql 1
        
        @event = Event.first
        @comment = Comment.last
        expect(@event.ancestor).to eql @project
        expect(@event.invoke_item).to eql @todo
        expect(@event.actor).to eql @user
        expect(@event.action_desc).to eql Event::DESC_COMMENT_ADD
        expect(@event.action_label).to eql Event::LABEL_COMMENT_ADD
        expect(@event.action_type).to eql "comment"
        expect(@event.comment_id).to eql @comment.id
        expect(@event.comment_content).to eql @comment.content
      end
    end


end
