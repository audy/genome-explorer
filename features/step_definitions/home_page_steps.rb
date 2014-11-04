When(/^I am on the homepage$/) do
  visit root_path
end

Then(/^I should see "(.*?)"$/) do |arg1|
    page.should have_content(arg1)
end
