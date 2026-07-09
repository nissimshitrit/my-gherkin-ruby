Feature: Calculator intentional failures
  To validate CI failure handling and JUnit failure reporting
  As a project maintainer
  I want a feature file that intentionally fails

  Scenario: Intentional failure for report verification
    Given the calculator starts at 1
    When I add 1
    Then the total should be 999

