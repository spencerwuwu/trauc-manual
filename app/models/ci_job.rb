class CiJob < ApplicationRecord
  belongs_to :target
  def start_job
    nt = Thread.new do
      log = "#{ENV['HOME']}/ci_logs/#{self.target_name}_latest.log"
      cmd = "cd ${HOME}/trauc-manual/contrib && ./wrapper.sh #{self.target_name} #{self.target_id} > #{log} 2>&1"
      logger.debug cmd
      #%x{ #{cmd} }
      result = system(cmd)
      logger.debug "Finish #{cmd} with code=#{result}"
    end
    nt.join
  end
end
