pipeline {
  triggers {
    gerrit(
      serverName: 'review.streamsets.net',
      gerritProjects: [[
        compareType: 'PLAIN',
        pattern: 'helm-charts',
        branches: [[ compareType: 'PLAIN', pattern: 'master' ]],
        disableStrictForbiddenFileVerification: false
      ]],
      triggerOnEvents: [
        patchsetCreated(excludeDrafts: true, excludeNoCodeChange: false, excludeTrivialRebase: false)
      ]
    )
  }

  agent {
    docker {
      image 'dtzar/helm-kubectl'
    }
  }

  stages {
    stage('lint') {
      steps {
        sh 'helm lint streamsets-control-agent'
        sh 'helm lint control-hub'
      }
    }
  }
}
