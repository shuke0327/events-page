class EventsController < ApplicationController
  before_action :authenticate_user!
  DEFAULT_EVENT_AMOUNT = 50

  def index
    @team = Team.find(params[:team_id]) if params[:team_id]
    @limit = params[:per_page] || DEFAULT_EVENT_AMOUNT
    page = params[:page] || 1
    @events = Event.paginate(page: page, per_page: @limit)
    respond_to do |format|
      format.html
      format.js
    end
  end


end