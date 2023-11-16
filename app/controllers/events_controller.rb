class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_volleyball_set, only: %i[create]

  layout false

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.volleyball_set = @volleyball_set

    respond_to do |format|
      if Events::CreateService.call(event: @event)
        format.turbo_stream
        format.json { render :show, status: :created, location: @event }
      else
        format.turbo_stream
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @volleyball_set = @event.volleyball_set

    Events::DestroyService.call(event: @event)

    respond_to do |format|
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_volleyball_set
      @volleyball_set = VolleyballSet.find(params[:volleyball_set_id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:player_id, :category, :rally_skill, :skill_point, :skill_error, :quality, :rotation)
    end
end
