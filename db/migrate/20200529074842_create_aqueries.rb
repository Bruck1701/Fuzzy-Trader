class CreateAqueries < ActiveRecord::Migration[6.0]
  def change
    create_table :aqueries do |t|
      t.float :query_value

      t.timestamps
    end
  end
end
