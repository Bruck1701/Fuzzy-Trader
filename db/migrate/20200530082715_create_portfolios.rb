class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.integer :user_id
      t.float :totalInv
      t.float :currentVal
      t.integer :cryptoAssets
      t.integer :shareAssets
      t.integer :totalAssets

      t.timestamps
    end
  end
end
