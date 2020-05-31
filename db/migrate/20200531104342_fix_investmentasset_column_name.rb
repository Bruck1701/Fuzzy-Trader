class FixInvestmentassetColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :investmentassets, :porfolio_id , :portfolio_id
  end
end
