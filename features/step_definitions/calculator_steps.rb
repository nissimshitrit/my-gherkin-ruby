# frozen_string_literal: true

Given("the calculator starts at {int}") do |starting_value|
  @total = starting_value
end

When("I add {int}") do |value|
  @total += value
end

Then("the total should be {int}") do |expected_total|
  raise "Expected #{expected_total}, got #{@total}" unless @total == expected_total
end

