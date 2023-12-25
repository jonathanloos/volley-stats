class Games::StatsService
  def self.attack_percentage(events:)
    kills = events.kills.count
    errors = events.attack_errors.count
    total_attempts = events.attack_attempts.count

    return 0 if total_attempts.zero?

    (kills - errors).to_f / total_attempts.to_f
  end

  def self.passing_average(events:)
    events.passing_events.where.not(quality: nil).average(:quality)
  end

  def self.points_earned(events:)
    events.where.not(skill_point: nil).count
  end

  def self.points_lost(events:)
    events.skill_error_serve.or(
      events.attack_errors
    ).or(
      events.skill_error_serve_receive
    ).count
  end
end