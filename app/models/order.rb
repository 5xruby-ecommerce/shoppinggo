class Order < ApplicationRecord
  belongs_to :user
  has_many :sub_order
end
