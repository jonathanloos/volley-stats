class Team < ApplicationRecord
  has_many :users
  has_many :games
  has_many :volleyball_sets
  belongs_to :head_coach, class_name: "User", optional: true
  belongs_to :assistant_coach, class_name: "User", optional: true

  def to_s
    text = "#{name}"
    text += " - #{year}" if year.present?
    text
  end
end
