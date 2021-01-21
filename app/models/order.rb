# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :sub_orders
  has_many :shop_orders
  before_create :order_number

  enum status: { pending: 0, paid: 1, cancelled: 2, deliver: 3 }

  include AASM

  aasm(column: :status, enum: true, no_direct_assignment: true) do
    state :pending, initial: true
    state :paid
    state :cancelled

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :cancel do
      transitions from: [:paid, :deliver, :pending], to: :cancelled
    end
  end

  private
  def order_number
    "shopA#{Time.zone.now.to_i.to_s}"
  end
end
