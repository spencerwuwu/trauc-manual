class FixTableIssues < ActiveRecord::Migration[5.2]
  def change
    remove_column :test_results, :target_name
    add_column :test_results, :benchmark, :string
  end
end
