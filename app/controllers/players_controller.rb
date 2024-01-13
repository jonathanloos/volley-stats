class PlayersController < ApplicationController
  before_action :set_player, only: %i[ show edit update destroy substitution ]
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
        format.html
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
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  def substitution
    @incoming_player = @player.volleyball_set.players.find(params[:player][:substitution_id])
    rotation = @player.rotation

    @event = Event.new(category: :substitution, player: @player, incoming_player: @incoming_player, volleyball_set: @player.volleyball_set)
    Events::CreateService.call(event: @event)

    @player.update(status: :bench, rotation: nil)
    @incoming_player.update(status: :on_court, rotation: rotation, role: @incoming_player.user.role)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    def set_volleyball_set
      @player = VolleyballSet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:user_id, :game_id, :volleyball_set_id, :role, :rotation)
    end
end
