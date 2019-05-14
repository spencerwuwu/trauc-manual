class CreateCiJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :ci_jobs do |t|
      t.string :target_name
      t.integer :status
      t.integer :target_id

      t.timestamps
    end
  end
end
