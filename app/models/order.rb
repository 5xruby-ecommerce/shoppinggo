# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :sub_orders

  enum status: { pending: 0, paid: 1, cancelled: 2, deliver: 3 }

  include AASM

  aasm(column: :status, enum: true, no_direct_assignment: true) do
    state :pending, initial: true
    state :paid, :cancelled

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :cancel do
      transitions from: [:paid, :deliver, :pending], to: :cancelled
    end
  end

  before_create :build_trade_no

  private
  def build_trade_no
    self.number = "shopA#{user.id.to_i}#{Time.zone.now.to_i.to_s}"
  end
end
