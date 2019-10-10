pipeline {
    agent none

    stages {
        stage('container') {
            agent {
                dockerfile {
                    args '-v ${HOME}/.m2:/home/builder/.m2'
                    additionalBuildArgs '--build-arg BUILDER_UID=$(id -u)'
                }
            }
            stages {
                stage('set_version_build') {
                    when { not { branch "master" } }
                    steps {
                        sh './bumpversion.sh build'
                    }
                }
                stage('set_version_release') {
                    when { branch "master" }
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'github-ci', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                            sh ('''
                                git config --local credential.helper "!f() { echo username=\\$GIT_USERNAME; echo password=\\$GIT_PASSWORD; }; f"
                                ./bumpversion.sh release
                            ''')
                        }
                    }
                }
                stage('build') {
                    steps {
                        sh 'mvn -B -DskipTests clean compile'
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
            }
            post {
                success {
                    archiveArtifacts artifacts: '**/geonetwork-imos-*.war,**/aodn-classifier-*.jar', fingerprint: true, onlyIfSuccessful: true
                }
            }
        }
    }
}
