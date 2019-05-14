class PageController < ApplicationController

  # Group result with its tool
  class ResultSet
    @target
    @results
    @status

    def initialize(target, result, job_status)
      @target = target
      @results = result
      @status = job_status
    end

    def target
      return @target
    end

    def results
      return @results
    end

    def status
      return @status
    end
  end

  def index
    @result_sets = []
    targets = Target.all

    targets.each do |target|
      results = TestResult.where(:target_id => target.id)
      job_status = CiJob.where(:target_id => target.id).first

      @result_sets << ResultSet.new(target, results, job_status.status)
    end
  end

  def log_path
  end

  def logerr_path
  end

  def run
    target_id = params[:id]
    cmd = "/home/spencerwu/Documents/trauc-manual/contrib/scripts/sleep.sh " + target_id + " &"
    %x{ #{cmd} }
    redirect_to_back_or_default
  end

end
