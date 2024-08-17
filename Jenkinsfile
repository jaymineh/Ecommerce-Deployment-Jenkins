pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        REPO_URL = 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
        DOCKER_IMAGE = 'jaymineh/webapp'
        DOCKER_TAG = 'latest'
        EC2_IP = '44.204.140.25'
    }

    stages {
        stage("Initial cleanup") {
          steps {
            dir("${WORKSPACE}") {
              deleteDir()
            }
          }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Deploy Code to Webserver') {
            steps {
                sshagent (['webserver']) {
                sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP}; pwd; whoami; git clone ${REPO_URL}"
                }
            }
        }
    }
}