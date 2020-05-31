class ChangeDefaultDataCheckingAccPortfolios < ActiveRecord::Migration[6.0]
  def change
    change_column :portfolios, :checkingacc, :float, :default => 0.0
  end
end
