Feature: Calculator
  To verify cucumber-ruby is wired correctly from Maven
  As a project maintainer
  I want a small executable acceptance test

  Scenario: Add two numbers
    Given the calculator starts at 0
    When I add 2
    And I add 3
    Then the total should be 5

  Scenario: Keep total unchanged when adding zero
    Given the calculator starts at 7
    When I add 0
    Then the total should be 7

  Scenario: Add a negative number
    Given the calculator starts at 10
    When I add -4
    Then the total should be 6

  Scenario: Add several numbers from a non-zero start
    Given the calculator starts at 5
    When I add 1
    And I add 2
    And I add 3
    Then the total should be 11
