FactoryGirl.define do

  factory :genome do
    # assembly_id has to be a sequence because it must be unique, by default FG
    # will just use `n` as the assembly_id.
    sequence :assembly_id
  end

end
