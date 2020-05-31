class AddTotalcurrvalToInvestmentassets < ActiveRecord::Migration[6.0]
  def change
    add_column :investmentassets, :totalcurrval, :float
  end
end
