class DelayedJobsController < ApplicationController
  def index
    @delayed_jobs = Delayed::Job.all
  end

  def show
    @delayed_job = Delayed::Job.find params[:id]
  end
end
