class CreateShopOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_orders do |t|
      t.integer :shop_id
      t.integer :order_id

      t.timestamps
    end
  end
end
