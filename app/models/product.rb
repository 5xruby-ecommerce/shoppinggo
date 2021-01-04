# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :order_item
  has_many :sub_order, through: :order_item
  belongs_to :shop

  validates :name, presence: true
  validates :price, presence: true

  mount_uploader :image, ImageUploader
  mount_uploaders :images, ImageUploader
  serialize :images
end
