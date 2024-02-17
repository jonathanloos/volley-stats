class Tournament < ApplicationRecord
  belongs_to :team
  has_many :games, dependent: :destroy

  def to_s
    title
  end
end
