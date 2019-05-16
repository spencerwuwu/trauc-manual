class CiJob < ApplicationRecord
  belongs_to :target
  def start_job
    nt = Thread.new do
      log = "#{ENV['HOME']}/ci_logs/#{self.target_name}_latest.log"
      cmd = "cd ${HOME}/trauc-manual/contrib && ./scripts/run_z3_branch_by_cron.sh #{self.target_name} #{self.target_id} > #{log} 2>&1"
      logger.debug cmd
      #%x{ #{cmd} }
      system(cmd)
      logger.debug "Finish #{cmd}"
    end
    nt.join
    self.update_attribute(:status, 0)
  end
end
