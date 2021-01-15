class AddReciverColumnToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :receiver, :string
    add_column :orders, :tel, :integer
    add_column :orders, :address, :string
  end
end
