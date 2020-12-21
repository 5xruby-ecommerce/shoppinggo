# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.bigint :sum
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
