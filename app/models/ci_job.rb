class CiJob < ApplicationRecord
  belongs_to :target
  def start_job
    # cmd = "cd #{Rails.root} && #{self.target_id.to_s}"
    # %x{ #{cmd} }
    self.update_attribute(:status, 0)
  end
end
