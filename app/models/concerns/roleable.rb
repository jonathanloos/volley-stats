module Roleable
  extend ActiveSupport::Concern

  included do
    enum role: {
      player: 0,
      coach: 1
    } # TODO: Add admin role
  end
end
