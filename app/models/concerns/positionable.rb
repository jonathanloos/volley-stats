module Positionable
  extend ActiveSupport::Concern

  included do
    enum position: {
      head_coach: 0,
      assistant_coach: 1,
      setter: 2,
      left_side: 3,
      right_side: 4,
      middle: 5,
      libero: 6
    }
  end
end
