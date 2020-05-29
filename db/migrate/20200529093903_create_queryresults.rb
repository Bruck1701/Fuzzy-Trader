class CreateQueryresults < ActiveRecord::Migration[6.0]
  def change
    create_table :queryresults do |t|
      t.integer :aquery_id
      t.string :qrname
      t.string :qrcategory
      t.float :qrcurrentvalue
      t.float :qrsixhigh
      t.float :qrsixlow
      t.integer :qrrecom

      t.timestamps
    end
  end
end
