Given(/^there's a feature type "(.*?)" $/) do |feature_type|
  @feature = FactorGirl.create(:feature, feature_type: feature_type)
end

When(/^I am on the feature page$/) do
  visit feature_path
end

Then(/^I should see feature type "(.?)"$/) do |feature_type|
  expect(page).have_content(feature_type)
end
