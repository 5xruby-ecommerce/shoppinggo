class UserCoupon < ApplicationRecord
  belongs_to :user
  belongs_to :coupon

  enum coupon_status: { used: 1, unused: 0 }

  include AASM

  aasm(:coupon_status) do
    state :unused, initial: true
    state :used

    event :use do
      transitions from: :unused, to: :used
    end

    event :cancel do
      transitions from: :used, to: :unused
    end
  end
end
