class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.integer :quantity
      t.decimal :price, precision: 8, scale:8

      t.timestamps
    end
  end
end
