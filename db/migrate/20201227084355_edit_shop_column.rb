class EditShopColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :shop, if_exist: true
    remove_column :products, :references, if_exist: true

    add_reference :products, :shop, index: true

  end
end
