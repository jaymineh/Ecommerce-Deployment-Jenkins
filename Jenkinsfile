pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_URL = 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
        DOCKER_IMAGE = 'jaymineh/webapp'
        DOCKER_TAG = 'latest'
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
                // Add your deployment script here
                // Example: ssh to the webserver and deploy the code
                sh '''
                ssh ubuntu@51.20.43.193 && git clone https://github.com/jaymineh/Jenkins-Pipeline-Simple
                '''
            }
        }
    }
}