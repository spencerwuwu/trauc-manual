class CreateTestResults < ActiveRecord::Migration[5.2]
  def change
    create_table :test_results do |t|
      t.integer :date
      t.integer :target_id
      t.integer :target_name
      t.string :commit
      t.integer :sat
      t.integer :unsat
      t.integer :timeout
      t.integer :misc
      t.integer :exception

      t.timestamps
    end
  end
end
