pipeline {
  agent any

  parameters {
    booleanParam(
      name: 'INCLUDE_INTENTIONAL_FAILURES',
      defaultValue: false,
      description: 'Include the intentionally-failing feature(s) in the Cucumber run'
    )
  }

  environment {
    // Workspace-local gem install avoids permission issues on the Jenkins service account
    BUNDLE_PATH = 'vendor/bundle'
    // Clear RUBYOPT - the Jenkins agent sets it to -F (a legacy flag invalid in Ruby 3.x)
    RUBYOPT = ''
  }

  stages {
    stage('Checkout') {
      steps {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          echo '========== Checking out repository =========='
          git branch: 'master',
              url: 'https://github.com/nissimshitrit/my-gherkin-ruby.git'
          echo "Repository checked out successfully from ${WORKSPACE}"
        }
      }
    }

    // stage('Bundle Install') {
    //   steps {
    //     catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
    //       bat '''
    //         setlocal EnableExtensions

    //         echo Ruby version:
    //         ruby --version

    //         echo --- Updating RubyGems to latest (fixes Windows path-with-spaces bug in Bundler) ---
    //         gem update --system --no-document

    //         echo --- Installing latest Bundler ---
    //         gem install bundler --no-document

    //         echo Bundler version:
    //         bundle --version

    //         echo --- Installing project gems ---
    //         bundle check
    //         if errorlevel 1 (
    //           echo Gems missing. Running bundle install...
    //           bundle install --jobs 4 --retry 3
    //         )

    //         echo Bundle complete. Gems path: %BUNDLE_PATH%
    //       '''
    //     }
    //   }
    // }

    stage('Run Cucumber (Ruby)') {
      steps {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          script {
            if (isUnix()) {
              error('This pipeline is configured for Windows agents. Please run on a Windows node.')
            }
          }

          bat """
            setlocal EnableExtensions
            rem RUBYOPT is parsed by ruby.exe at startup, before run_cucumber.rb can clear
            rem it via ENV.delete - so it MUST be cleared here, not relying solely on the
            rem pipeline environment block.
            set "RUBYOPT="
            set "INCLUDE_INTENTIONAL_FAILURES=${params.INCLUDE_INTENTIONAL_FAILURES}"
            ruby scripts\\run_cucumber.rb
          """
        }
      }
    }

    stage('Run bdd2octane') {
      steps {
        catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
          bat '''
                  echo Checking if bdd2octane is available...
                  if exist "C:\\bdd2octane\\bdd2octane-1.1.14-beta-SNAPSHOT.jar" (
                      echo Running bdd2octane...
                      java -jar "C:\\bdd2octane\\bdd2octane-1.1.14-beta-SNAPSHOT.jar" --reportFiles=reports/**/*.xml --featureFiles=features/*.feature --framework=cucumber-ruby
                      echo bdd2octane conversion completed
                  ) else (
                      echo bdd2octane jar not found at C:\\bdd2octane\\bdd2octane-1.1.14-beta-SNAPSHOT.jar
                  )
              '''
        }
      }
    }
  }

  post {
    always {
      publishGherkinResults 'cucumber-ruby-result.xml'
    }
  }
}