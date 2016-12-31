require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create(:user)
    @team = create(:team)
    @project = create(:project, team: @team)
    @user.set_team!(@team)
    @user.set_access_to_project!(@project)
  end

  describe "require user login" do
    it 'is the current user as required' do
      get :index
      expect(response).to redirect_to new_user_session_path
    end

    it 'render the index page' do
      sign_in @user
      get :index
      expect(response).to be_success
      expect(response).to render_template :index
    end

    it 'logins successfully' do
      sign_in @user
      get :index
      expect(subject.current_user).to eql(@user)
    end
  end


  describe "events page index" do
    render_views
    before :each do
      sign_in @user
      @todos = 20.times {Todo.create(content: Faker::Lorem.word, creator: @user, project: @project)}
    end

    it "should have the right amount of events" do
      get :index, format: :html
      expect(assigns(:events).count).to eql 20
    end

    it "should receive the per_page params" do
      get :index, per_page: 10, format: :html
      expect(assigns(:events).length).to eql 10
    end

    context "when user created todos in other team" do
      before :each do
        @other_team = create(:team)
        @other_project = create(:project, team: @other_team)
        @user.set_team!(@other_team)
        @user.set_access_to_project!(@other_project)
        @other_todos = 20.times {Todo.create(content: Faker::Lorem.word,
                                 creator: @user, project: @other_project)}
      end

      it "should not show in the current team events page" do
        get :index, format: :html
        expect(assigns(:team)).to eql @team
        team = assigns(:events).map(&:team).uniq
        expect(team.length).to eql 1
        expect(team).to include @team
        expect(team).to_not include @other_team
      end

      it "should show in other team events page" do
        get :index, team_id: @other_team.id, format: :html
        expect(assigns(:team)).to eql @other_team
        team = assigns(:events).map(&:team).uniq
        expect(team.length).to eql 1 
        expect(team).to include @other_team
        expect(team).to_not include @team
      end
    end

    context "when user create todos in other project in the current team" do
      before :each do
        @other_project = create(:project, team: @team)
        @user.set_access_to_project!(@other_project)
        @other_todos = 20.times {Todo.create(content: Faker::Lorem.word,
                                 creator: @user, project: @other_project)}
      end

      it "should show in the current users events page" do
        get :index, format: :html
        expect(assigns(:events).map(&:ancestor).uniq).to include @other_project
      end
    end

    context "whe other user in the same team create todos" do
      before :each do
        @other_user = create(:user)
        @other_user.set_team!(@team)
        @other_user.set_access_to_project!(@project)
        @other_todos = 20.times {Todo.create(content: Faker::Lorem.word,
                                 creator: @other_user, project: @project)}
      end

      it "should show in the current users events page" do
        get :index, format: :html
        expect(assigns(:events).map(&:actor).uniq).to include @other_user
      end
    end
  end
end