class ChangeShopIdTypeInProduct < ActiveRecord::Migration[6.0]
  def self.up
    change_column :products, :shop_id, "integer USING shop_id::integer"
  end

  def self.down
    change_column :products, :shop_id, "varchar USING shop_id::varchar"
  end
end
