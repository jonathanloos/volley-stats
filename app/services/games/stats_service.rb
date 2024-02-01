class Games::StatsService
  def self.attack_percentage(events:)
    kills = events.kills.count
    errors = events.attack_errors.count
    total_attempts = events.attack_attempts.count

    return 0 if total_attempts.zero?

    (kills - errors).to_f / total_attempts.to_f
  end

  def self.passing_average(events:)
    events.passing_events.where.not(quality: nil).average(:quality) || 0
  end

  def self.free_ball_passing_average(events:)
    events.free_ball_passing_events.where.not(quality: nil).average(:quality) || 0
  end

  def self.points_earned(events:, team:)
    events.where(team: team).where.not(skill_point: nil).or(
      events.where.not(team: team).skill_error_serve_receive
    ).count
  end

  def self.points_given(events:, team:)
    events.where(team: team).where.not(skill_error: [nil, :serve_receive]).count
  end

  def self.aces(events:, home_team:)
    # away team can't have reception errors or aces, everything is logged on the home team
    if home_team
      events.skill_point_ace.count
    else
      events.skill_error_serve_receive.count
    end
  end
end