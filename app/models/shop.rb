# frozen_string_literal: true

class Shop < ApplicationRecord
  belongs_to :user
  has_many :products
  has_many :coupons
  
  validates :name, presence: true
  validates :tel, presence: true
end
