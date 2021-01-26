class Coupon < ApplicationRecord
  belongs_to :shop
  has_many :user_coupons

  enum discount_rule: [:percent, :dollor]
end
