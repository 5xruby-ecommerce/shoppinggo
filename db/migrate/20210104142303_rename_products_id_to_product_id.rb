class RenameProductsIdToProductId < ActiveRecord::Migration[6.0]
  def change
    rename_column :order_items, :products_id, :product_id
  end
end
