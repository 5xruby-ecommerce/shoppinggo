class SetDefaultToProductStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :status, 0
  end
end
