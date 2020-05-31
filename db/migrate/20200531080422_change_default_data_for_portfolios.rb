class ChangeDefaultDataForPortfolios < ActiveRecord::Migration[6.0]
  def change
    change_column :portfolios, :totalInv, :float, :default => 0.0
    change_column :portfolios, :currentVal, :float, :default => 0.0
    change_column :portfolios, :cryptoAssets, :integer, :default => 0
    change_column :portfolios, :shareAssets, :integer, :default => 0
    change_column :portfolios, :totalAssets, :integer, :default => 0

  end
end

