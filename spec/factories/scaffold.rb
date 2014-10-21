FactoryGirl.define do

  factory :scaffold do
    # sequence must be defined explicitly using add_attribute because
    # factorygirl already has a method name sequence which causes all sorts of
    # weirdnesses to occur
    add_attribute :sequence, 'ATGGATCAATGA' 
    genome
  end

end
