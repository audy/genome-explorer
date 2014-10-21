FactoryGirl.define do

  factory :feature do
    scaffold
    feature_type 'CDS'
    start 1
    stop 12
  end

end
