# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :sub_order

  include AASM

  aasm(column: 'state', no_direct_assignment: true) do
    state :pending, initial: true
    state :paid, :cancelled

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :cancel do
      transitions from: [:paid, :deliver, :pending], to: :cancelled
    end
  end



end
