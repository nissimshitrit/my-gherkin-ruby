# my-gherkin-ruby

This project runs **cucumber-ruby 7.0.0**.

## What is configured

- `Gemfile` pins `cucumber` to `7.0.0`
- Cucumber features and step definitions are in `features/`
- `scripts/run_cucumber.rb` runs Cucumber with:
  - console progress output
  - JUnit XML output to `reports/junit`

## Prerequisites

- Ruby **>= 2.7 and < 3.4**
- Bundler (`gem install bundler`)

## Important note about Maven

`mvn test` is currently not available in this workspace because `pom.xml` is not present.
If you want Maven execution again, add/restore `pom.xml` and wire it to run `bundle install` and `ruby scripts/run_cucumber.rb`.

## Run tests (Ruby)

Install gems:

```powershell
bundle install
```

Run all features through the project runner:

```powershell
ruby .\scripts\run_cucumber.rb
```

## Passing-only run vs intentional-failure run

This repository includes `features/calculator_failures.feature` with an intentional failing scenario.

Run only passing scenarios:

```powershell
bundle exec cucumber --strict --format progress --format junit --out reports/junit features/calculator.feature
```

Run all scenarios (includes intentional failure, expected non-zero exit):

```powershell
bundle exec cucumber --strict --format progress --format junit --out reports/junit features
```

## Test reports

JUnit XML reports are written to `reports/junit` as `TEST-*.xml` files.
