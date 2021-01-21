class ShopOrder < ApplicationRecord
  belongs_to :shop
  belongs_to :order
end
