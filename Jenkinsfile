pipeline {
  agent {
    docker {
      image 'dtzar/helm-kubectl'
    }

  }
  stages {
    stage('lint') {
      steps {
        sh 'helm lint control-hub'
      }
    }
  }
}