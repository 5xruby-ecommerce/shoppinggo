class Shop < ApplicationRecord
  belongs_to :user
  has_many :products

  validates :name, presence: true
  validates :tel, presence: true

end
