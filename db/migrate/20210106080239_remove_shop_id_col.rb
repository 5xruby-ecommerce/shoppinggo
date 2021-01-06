class RemoveShopIdCol < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :shop_id
  end
end
