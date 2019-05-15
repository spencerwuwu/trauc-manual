class AddUnknownToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :test_results, :unknown, :integer
  end
end
