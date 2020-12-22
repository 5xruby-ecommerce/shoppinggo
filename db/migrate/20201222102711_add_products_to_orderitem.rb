class AddProductsToOrderitem < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :products_id , :bigint
  end
end
