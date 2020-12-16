class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.string :tel
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
