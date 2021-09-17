pipeline {
    agent none

    stages {
        stage('container') {
            agent {
                dockerfile {
                    args '-v ${HOME}/.m2:/home/builder/.m2 -v ${HOME}/bin:${HOME}/bin'
                    additionalBuildArgs '--build-arg BUILDER_UID=$(id -u)'
                }
            }
            stages {
                stage('clean') {
                    steps {
                        sh 'git reset --hard'
                        sh 'git clean -xffd'
                    }
                }
                stage('set_version_release') {
                    when { branch 'master' }
                    steps {
                        withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIALS_ID, passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            sh './bumpversion.sh'
                        }
                    }
                }
                stage('build') {
                    steps {
                        sh 'mvn -U -B -DskipTests clean compile'
                    }
                }
                stage('test') {
                    steps {
                        sh 'mvn -B test'
                    }
                }
                stage('package') {
                    steps {
                        sh 'mvn -B -DskipTests package'
                    }
                }
                stage('integration_test') {
                    steps {
                        sh 'mvn -B test-compile failsafe:integration-test failsafe:verify'
                    }
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/geonetwork-imos-*.war,**/aodn-classifier-*.jar,**/aodn-listeners-*.jar', fingerprint: true, onlyIfSuccessful: true
                }
            }
        }
    }
}
