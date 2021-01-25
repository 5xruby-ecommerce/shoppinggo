# frozen_string_literal: true

class SubOrder < ApplicationRecord
  belongs_to :order
  has_many :order_items
  has_many :products, through: :order_items
end
