pipeline {
    agent any

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

        stage('Deploy to Webserver') {
            steps {
                sshagent (['webserver']) {
                sh "ssh -T ubuntu@${EC2_IP} && git clone ${REPO_URL}"
                }
            }
        }
    }
}