class EventsController < ApplicationController
  DEFAULT_DEVENTS_amount = 50
  def index
    @events = Event.select(params[:events_amount] || DEFAULT_DEVENTS_COUNT)
  end
end