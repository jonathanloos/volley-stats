class VolleyballSetsController < ApplicationController
  before_action :set_volleyball_set, only: %i[ show edit update destroy log_events ]
  before_action :set_game, only: %i[ create ]

  # GET /volleyball_sets or /volleyball_sets.json
  def index
    @volleyball_sets = VolleyballSet.all
  end

  # GET /volleyball_sets/1 or /volleyball_sets/1.json
  def show
  end

  # GET /volleyball_sets/new
  def new
    @volleyball_set = VolleyballSet.new
  end

  # GET /volleyball_sets/1/edit
  def edit
  end

  # POST /volleyball_sets or /volleyball_sets.json
  def create
    @volleyball_set = VolleyballSet.new(volleyball_set_params)
    @volleyball_set.game = @game
    @volleyball_set.serving_team = @game.home_team
    @volleyball_set.receiving_team = @game.home_team
    @volleyball_set.setter_rotation = @volleyball_set.starting_setter_rotation

    respond_to do |format|
      if @volleyball_set.save
        format.html { redirect_to @volleyball_set.game, notice: "Volleyball set was successfully created." }
        format.json { render :show, status: :created, location: @volleyball_set }
      else
        format.html { redirect_to @volleyball_set.game, alert: "Could not create set.", status: :unprocessable_entity }
        format.json { render json: @volleyball_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /volleyball_sets/1 or /volleyball_sets/1.json
  def update
    respond_to do |format|
      if @volleyball_set.update(volleyball_set_params)
        format.html { redirect_to @volleyball_set.game, notice: "Volleyball set was successfully updated." }
        format.json { render :show, status: :ok, location: @volleyball_set }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @volleyball_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volleyball_sets/1 or /volleyball_sets/1.json
  def destroy
    @volleyball_set.destroy

    respond_to do |format|
      format.html { redirect_to @volleyball_set.game, notice: "Volleyball set was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /volleyball_sets/1/log_events
  def log_events
    @events = @volleyball_set.events
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volleyball_set
      @volleyball_set = VolleyballSet.find(params[:id])
    end

    def set_game
      @game = Game.find(params[:game_id])
    end

    # Only allow a list of trusted parameters through.
    def volleyball_set_params
      params.require(:volleyball_set).permit(:starting_setter_rotation, :serving_team_id)
    end
end
