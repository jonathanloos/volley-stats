class Organization < ApplicationRecord
  belongs_to :user
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy

  validates :category, presence: true

  enum category: {
    club: 0
  }

  def to_s
    title
  end
end
