class Event < ApplicationRecord
  include Roleable

  belongs_to :game
  belongs_to :player, optional: true
  belongs_to :team
  belongs_to :user, optional: true
  belongs_to :volleyball_set

  acts_as_list scope: :volleyball_set

  validates :category, presence: true
  validates :player_rotation, numericality: { only_integer: true, in: 1..6 }
  validates :setter_rotation, numericality: { only_integer: true, in: 1..6 }
  validates :home_score, numericality: { only_integer: true }
  validates :away_score, numericality: { only_integer: true }

  enum category: {
    point_earned: 0,
    point_given: 1,
    continuation: 2,
    substitution: 3,
    timeout: 4,
    rotation: 5
  }

  enum rally_skill: {
    free_ball: 0,
    hit_in_play: 1,
    block_in_play: 2,
    serve_receive: 3,
    free_ball_receive: 4,
    dig: 5,
    serve: 6
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
    set: 5,
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
    ace: :attacking
  }.with_indifferent_access

  def to_s
    text = "#{position}. #{category.humanize}: "
    text += if category == "point_earned"
      "#{skill_point.humanize.titleize} by #{user}"
    elsif category == "point_given"
      "#{skill_error.humanize.titleize} by #{user}"
    else
      "#{rally_skill.humanize.titleize} by #{user}"
    end

    text += " - #{quality} quality" if quality.present?
    text += " - player rotation: #{player_rotation}"
    text += " - setter rotation: #{setter_rotation}"
    text += " - #{home_score} | #{away_score}"
    text
  end
end
