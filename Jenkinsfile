pipeline {
  agent {
    docker {
      image 'kunickiaj/chart-testing'
      args '--user root:root'
    }
  }

  stages {
    stage('checkout') {
      steps {
        checkout(
          [
            $class: 'GitSCM',
            branches: [
              [
                name: '$GERRIT_BRANCH'
              ]
            ],
            doGenerateSubmoduleConfigurations: false,
            extensions: [
              [
                $class: 'BuildChooserSetting',
                 buildChooser: [
                   $class: 'GerritTriggerBuildChooser'
                   ]
              ]
            ],
            submoduleCfg: [],
            userRemoteConfigs: [
              [
                credentialsId: 'a7eecc22-353e-499e-bfa0-754e69fb197a',
                refspec: '$GERRIT_REFSPEC',
                url: 'ssh://streamsets-ci@review.streamsets.net:29418/helm-charts'
              ]
            ]
          ]
        )
      }
    }
    stage('lint') {
      steps {
        sh "#!/bin/sh\nct lint --chart-dirs . --validate-maintainers=false --debug"
      }
    }
  }
}
