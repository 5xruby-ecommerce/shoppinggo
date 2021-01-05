class RenameShopToShopId < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :shop, :shop_id
  end
end
