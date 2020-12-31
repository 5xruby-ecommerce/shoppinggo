# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :order_item
  has_many :sub_orders, through: :order_item

  validates :name, presence: true
  validates :price, presence: true
end
