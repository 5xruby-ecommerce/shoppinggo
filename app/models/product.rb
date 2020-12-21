# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :order_item
  has_many :sub_order, through: :order_item

  validates :name, presence: true
  validates :content, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
end
