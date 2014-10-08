class DelayedJobsController < ApplicationController
  def index
    @delayed_jobs = Delayed::Job.all
  end

  def show
    @delayed_job = Delayed::Job.find params[:id]
  end

  def destroy
    Delayed::Job.find(params[:id]).destroy
    redirect_to delayed_jobs_path, flash: { notice: 'Job cancelled' }
  end

end
