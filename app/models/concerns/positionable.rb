module Positionable
  extend ActiveSupport::Concern

  included do
    enum position: {
      setter: 1,
      left_side: 2,
      right_side: 3,
      middle: 4,
      libero: 5
    }, _prefix: :volleyball
  end
end
