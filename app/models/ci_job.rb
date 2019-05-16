class CiJob < ApplicationRecord
  belongs_to :target
  def start_job
    Thread.new do
      log = "#{ENV['HOME']}/ci_logs/#{self.target_name}_latest.log"
      cmd = "cd ${HOME}/trauc-manual/contrib && ./scripts/run_z3_branch_by_cron.sh #{self.target_name} #{self.target_id} &> #{log}"
      puts cmd
      #%x{ #{cmd} }
      system(cmd)
      self.update_attribute(:status, 0)
    end
  end
end
