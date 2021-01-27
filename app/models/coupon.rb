class Coupon < ApplicationRecord
  belongs_to :shop
  has_many :user_coupons

  enum discount_rule: [:折扣, :金額]
end