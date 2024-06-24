pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_URL = 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
        DOCKER_IMAGE = 'jaymineh/webapp'
        DOCKER_TAG = 'latest'
        EC2_IP = '51.20.43.193'
    }

    stages {
        stage("Initial cleanup") {
          steps {
            dir("${WORKSPACE}") {
              deleteDir()
            }
          }
        }

        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
            }
        }

        stage('Deploy to Webserver') {
            steps {
                sshagent (['webserver']) {
                sh "ssh -tt ubuntu@${EC2_IP} && git clone ${REPO_URL}"
                }
            }
            
        }
    }
}