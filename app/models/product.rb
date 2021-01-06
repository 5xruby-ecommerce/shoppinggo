# frozen_string_literal: true

class Product < ApplicationRecord

  has_many :order_items
  has_many :sub_orders, through: :order_item

  belongs_to :shop

  validates :name, presence: true
  validates :price, presence: true

  mount_uploader :image, ImageUploader
  mount_uploaders :images, ImageUploader
  serialize :images
end
