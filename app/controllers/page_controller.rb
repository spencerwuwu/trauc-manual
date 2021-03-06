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

    @can_runall = true
    targets.each do |target|
      results = TestResult.where(:target_id => target.id)
      job_status = CiJob.where(:target_id => target.id).first

      @result_sets << ResultSet.new(target, results, job_status.status)
      if job_status.status == 1
          @can_runall = false
      end
    end

  end

  def run
    target_job = CiJob.where(:target_id => params[:id]).first
    if target_job.status == 0
      target_job.status = 1
      target_job.save
      target_job.delay.start_job
    end
    redirect_back(fallback_location: root_path)
  end

  def run_all
    target_jobs = CiJob.all
    target_jobs.each do |target_job|
      if target_job.status == 0
        target_job.status = 1
        target_job.save
        target_job.delay.start_job
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def log
    id = params[:id]
    result = TestResult.where(:id => params[:id]).first
    dir = "/home/deploy/ci_logs_full/trauc-#{result.date}-#{result.benchmark}/"
    target = dir + "#{result.benchmark}.#{result.date}.trauc.log"

    @content = File.read(target)
  end

  def logerr
    id = params[:id]
    result = TestResult.where(:id => params[:id]).first
    dir = "/home/deploy/ci_logs_full/trauc-#{result.date}-#{result.benchmark}/"
    target = dir + "#{result.benchmark}.#{result.date}.trauc.log.err"

    @content = File.read(target)
  end

end
