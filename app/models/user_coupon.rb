class UserCoupon < ApplicationRecord
  belongs_to :user
  belongs_to :coupon

  enum coupon_status: { used: 1, unused: 0 }
end
