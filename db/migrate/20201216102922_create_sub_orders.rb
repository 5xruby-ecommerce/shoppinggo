# frozen_string_literal: true

class CreateSubOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_orders do |t|
      t.bigint :sum
      t.integer :status
      t.text :comment
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
