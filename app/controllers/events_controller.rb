class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_team, only: [:index]
  DEFAULT_EVENT_AMOUNT = 50

  def index
    if @team.present?
      @accessable_projects = current_user.accessable_projects_in(@team)
      @limit = params[:per_page] || DEFAULT_EVENT_AMOUNT
      page = params[:page] || 1
      @events = Event.ancestor_events(@accessable_projects).paginate(page: page, per_page: @limit)
      respond_to do |format|
        format.html
        format.js
        format.json
      end
    end
  end

  private
    def get_team
    if params[:team_id]
      @team = current_user.teams.find_by(id: params[:team_id])
    else
      @team = current_user.default_team
    end
  end

end