class UserCoupon < ApplicationRecord
  belongs_to :user
  belongs_to :coupon

  enum coupon_status: [:used, :unused]
end
