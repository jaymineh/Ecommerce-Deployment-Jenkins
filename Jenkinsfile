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
                git branch: 'main', url: 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
            }
        }

        stage('Deploy Code to Webserver') {
            steps {
                sshagent (['webserver']) {
                sh "ssh -T ubuntu@${EC2_IP} && git clone ${REPO_URL}"
                }
            }
        }
    }
}