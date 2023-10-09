module Roleable
  extend ActiveSupport::Concern

  included do
    enum role: {
      setter: 1,
      left_side: 2,
      right_side: 3,
      middle: 4,
      libero: 5
    }
  end
end
