class ModifyQueryResultColumnsRenameAndAdd < ActiveRecord::Migration[6.0]
  def change

    rename_column :queryresults, :qrsixhigh, :qrhigh
    rename_column :queryresults, :qrsixlow, :qrlow

    add_column :queryresults, :qraverage, :float
    add_column :queryresults, :qravgperiod, :integer


  end
end
