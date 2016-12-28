class EventsController < ApplicationController
  before_action :authenticate_user!
  DEFAULT_EVENT_AMOUNT = 50
  def index
    @team = Team.find(params[:team_id]) if params[:team_id].present?
    @events = Event.limit(params[:limit] || DEFAULT_EVENT_AMOUNT)
  end
end