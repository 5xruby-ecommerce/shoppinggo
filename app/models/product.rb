class Product < ApplicationRecord
  has_many :order_item
  has_many :sub_order, through: :order_item
end
