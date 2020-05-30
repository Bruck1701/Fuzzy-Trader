class LinkQuerytoUser < ActiveRecord::Migration[6.0]
  def change
    add_column :aqueries, :user_id, :integer

  end
end
