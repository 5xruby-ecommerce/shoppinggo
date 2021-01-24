class AddProductRefToOrderItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_items, :product_id, :bigint

    add_reference :order_items, :product, index: true
  end
end
