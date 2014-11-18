describe 'the application' do

  it 'can be loaded (eager loads everything)' do
    Rails.application.eager_load!
  end
end
