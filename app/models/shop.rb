# frozen_string_literal: true

class Shop < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :coupons
  has_many :shop_orders
  has_many :orders, through: :shop_orders
  validates :name, presence: true
  validates :tel, presence: true
end
