class AddCheckingaccToPortfolios < ActiveRecord::Migration[6.0]
  def change
    add_column :portfolios, :checkingacc, :float
  end
end
