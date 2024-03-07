class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy substitution libero_substitution]
  before_action :set_volleyball_set, only: %i[create]

  layout false

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = Player.new(player_params)
    @player.volleyball_set = @volleyball_set
    @player.game = @volleyball_set.game
    @player.team = @volleyball_set.game.home_team

    respond_to do |format|
      if @player.save
        format.turbo_stream
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html {redirect_to @player.game, notice: "Player Saved"}
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy

    respond_to do |format|
      format.html {redirect_to @player.game, notice: "#{@player.full_name} removed from roster."}
      format.json { head :no_content }
    end
  end

  def substitution
    @incoming_player = @player.volleyball_set.players.find(params[:player][:substitution_id])
    Players::SubstitutionService.call(incoming_player: @incoming_player, player: @player)
    @event = @player.volleyball_set.events.last
  end

  def libero_substitution
    @libero = @player.volleyball_set.players.find_by(starting_libero: true)

    @incoming_player = if @player == @libero
      @player.volleyball_set.events.libero_substitution.last.player
    else
      @player.volleyball_set.players.find_by(starting_libero: true)
    end

    Players::SubstitutionService.call(incoming_player: @incoming_player, player: @player)
    @event = @player.volleyball_set.events.last
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    def set_volleyball_set
      @volleyball_set = VolleyballSet.find(params[:volleyball_set_id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:user_id, :game_id, :volleyball_set_id, :role, :rotation, :position, :back_row_position, :front_row_position)
    end
end
