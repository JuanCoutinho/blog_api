class AddFeelingToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :feeling, :integer
  end
end
