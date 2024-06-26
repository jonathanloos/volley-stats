class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy stats ]

  layout "admin"

  # GET /games or /games.json
  def index
    @games = Game.all.order(date: :desc)
    @games = @games.where(tournament_id: params[:tournament_id]) if params[:tournament_id].present?
  end

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /games/1/stats
  def stats
    @volleyball_sets = params[:volleyball_set_id].present? ? [@game.volleyball_sets.find(params[:volleyball_set_id])] : @game.volleyball_sets
    @events = @game.events.where(volleyball_set: @volleyball_sets)
    @home_team_events = @events.where(team: @game.home_team)
    @away_team_events = @events.where(team: @game.away_team)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:home_team_id, :away_team_id, :title, :date, :tournament_id)
  end
end
