# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :sub_order
  belongs_to :product
end
