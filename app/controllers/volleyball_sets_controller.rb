class VolleyballSetsController < ApplicationController
  before_action :set_volleyball_set, only: %i[ show edit update destroy log_events set_lineup ]
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

    respond_to do |format|
      if VolleyballSets::CreateService.call(volleyball_set: @volleyball_set, game: @game)
        format.html { redirect_to @game, notice: "Volleyball set was successfully created." }
        format.json { render :show, status: :created, location: @volleyball_set }
      else
        format.html { redirect_to @game, alert: "Could not create set.", status: :unprocessable_entity }
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

  def set_lineup
    debugger
    if VolleyballSets::LineupService.call(volleyball_set: @volleyball_set, rotation_one_id: params[:rotation_one_id], rotation_two_id: params[:rotation_two_id], rotation_three_id: params[:rotation_three_id], rotation_four_id: params[:rotation_four_id], rotation_five_id: params[:rotation_five_id], rotation_six_id: params[:rotation_six_id], libero_id: params[:libero_id])
      redirect_to @volleyball_set.game, status: :see_other, notice: "Lineup Saved"
    else
      redirect_to @volleyball_set.game, status: :unprocessable_entity, notice: "Error setting lineup: #{@volleyball_set.errors.full_messages.join(", ")}"
    end
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
