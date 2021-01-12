class ChangeNumberColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :number, :string
  end
end
