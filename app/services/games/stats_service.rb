class Games::StatsService
  def self.game_hitting_percentage(game)
    kills = game.events.skill_point_attack.count
    errors = game.events.skill_error_attack.count
    total_attempts = game.events.total_attack_attempts.count

    return 0 if total_attempts.zero?

    (kills - errors).to_f / total_attempts.to_f
  end
end