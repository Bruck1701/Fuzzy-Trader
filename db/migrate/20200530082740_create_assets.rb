class CreateAssets < ActiveRecord::Migration[6.0]
  def change
    create_table :assets do |t|
      t.integer :porfolio_id
      t.string :category
      t.string :name
      t.float :qty
      t.float :purchaseValue

      t.timestamps
    end
  end
end
