class CreateShopOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_orders do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
