class Event < ApplicationRecord
  include Roleable

  KILL_CATEGORIES = [:attack, :tip, :dump, :downball]
  ATTACK_ERROR_CATEGORIES = [:attack, :tip, :dump, :downball, :third_contact]
  IN_RALLY_THIRD_CONTACTS = [:hit_in_play, :free_ball]
  BALL_HANDLING_ERRORS = [:double, :lift, :second_contact]

  belongs_to :game
  belongs_to :player, optional: true
  belongs_to :incoming_player, class_name: "Player", optional: true
  belongs_to :team
  belongs_to :user, optional: true
  belongs_to :volleyball_set

  acts_as_list scope: :volleyball_set

  before_save :check_if_after_timeout

  validates :category, presence: true
  validates :player_rotation, numericality: { only_integer: true, in: 1..6 }, if: -> { player.present? && team != game.away_team && !user.coach?}
  validates :setter_rotation, numericality: { only_integer: true, in: 1..6 }
  validates :home_score, numericality: { only_integer: true }
  validates :away_score, numericality: { only_integer: true }
  validates :incoming_player, presence: true, if: -> {substitution? || libero_substitution?}

  scope :points, -> { where(category: [:point_earned, :point_given]) }
  scope :attack_attempts, -> { where(rally_skill: IN_RALLY_THIRD_CONTACTS).or(
      where(skill_point: KILL_CATEGORIES)
    ).or(
      where(skill_error: ATTACK_ERROR_CATEGORIES)
    )
  }

  scope :serve_attempts, -> { where(rally_skill: :serve).or(
    where(skill_point: :ace)
  ).or(
    where(skill_error: :serve)
  )
}

  scope :passing_events, -> { where(rally_skill: :serve_receive).or(
      where(skill_error: :serve_receive)
    )
  }

  scope :free_ball_passing_events, -> { where(rally_skill: :free_ball_receive).or(
    where(skill_error: :free_ball_receive)
  )
}

  scope :kills, -> { where(skill_point: KILL_CATEGORIES) }
  scope :attack_errors, -> { where(skill_error: ATTACK_ERROR_CATEGORIES) }
  scope :ball_handling_errors, -> { where(skill_error: BALL_HANDLING_ERRORS) }

  enum category: {
    point_earned: 0,
    point_given: 1,
    continuation: 2,
    substitution: 3,
    timeout: 4,
    libero_substitution: 5
  }

  enum rally_skill: {
    free_ball: 0,
    hit_in_play: 1,
    block_in_play: 2,
    serve_receive: 3,
    free_ball_receive: 4,
    dig: 5,
    serve: 6,
    assist: 7
  }, _prefix: true

  enum skill_point: {
    ace: 0,
    attack: 1,
    tip: 2,
    dump: 3,
    downball: 4,
    block: 5,
    other: 6
  }, _prefix: true

  enum skill_error: {
    serve: 0,
    serve_receive: 1,
    attack: 2,
    dig: 3,
    tip: 4,
    double: 5,
    dump: 6,
    free_ball_receive: 7,
    downball: 8,
    second_contact: 9,
    block: 10,
    third_contact: 11,
    net: 12,
    lift: 13,
    under: 14,
    over: 15,
    foot_fault: 16,
    out_of_rotation: 17,
    back_row_attack: 18
  }, _prefix: true

  QUALITY_CATEGORIES = {
    serve_receive: :passing,
    attack: :attacking,
    tip: :attacking,
    dump: :attacking,
    downball: :attacking,
    hit_in_play: :attacking,
    serve: :serving,
    ace: :attacking,
    free_ball_receive: :passing
  }.with_indifferent_access

  def to_s
    text = "#{position}. #{category.humanize}: "
    text += if point_earned?
      "#{skill_point.humanize.titleize} by #{user || team}"
    elsif point_given?
      "#{skill_error.humanize.titleize} by #{user || team}"
    elsif rally_skill?
      "#{rally_skill.humanize.titleize} by #{user || team}"
    elsif substitution? || libero_substitution?
      "#{incoming_player} in for #{player}"
    elsif timeout?
      "Timeout called by #{user || team}"
    end

    text += " - #{quality} quality" if quality.present?
    text += " - player rotation: #{player_rotation}" if player_rotation.present?
    text += " - setter rotation: #{setter_rotation}"
    text += " - #{home_score} | #{away_score}"
    text += "AFTER TIMEOUT" if after_timeout?
    text
  end

  def short_text
    if rally_skill?
      rally_skill.humanize
    elsif skill_point?
      skill_point.humanize
    elsif skill_error
      skill_error.humanize
    end
  end

  private

  def check_if_after_timeout
    # self.after_timeout = volleyball_set.events.any? && volleyball_set.events.last.timeout?
    # if there was a timeout
    # and since that timeout no point has been won
    most_recent_timout = volleyball_set.events.timeout.last
    return unless most_recent_timout.present?

    self.after_timeout = most_recent_timout.lower_items.where(category: [:point_given, :point_earned]).empty?
  end
end
