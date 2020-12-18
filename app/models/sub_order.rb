# frozen_string_literal: true

class SubOrder < ApplicationRecord
  belongs_to :order
  has_many :order_item
  has_many :product, through: :order_item
end
