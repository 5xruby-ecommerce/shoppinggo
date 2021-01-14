class Coupon < ApplicationRecord
  belongs_to :shop
  enum discount_rule: [:percent, :dollor, :shipment]
end
