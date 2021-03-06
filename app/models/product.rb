# frozen_string_literal: true
class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  acts_as_taggable_on :categories
  has_many :order_items
  has_many :sub_orders, through: :order_items
  has_many :favorite_products, dependent: :delete_all
  has_many :favorite_users, through: :favorite_products, source: 'user'

  belongs_to :shop

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  mount_uploader :image, ImageUploader
  mount_uploaders :images, ImageUploader
  serialize :images

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  def slug_candidates
    [
      :name,
      [:name, :price]
    ]
  end
end