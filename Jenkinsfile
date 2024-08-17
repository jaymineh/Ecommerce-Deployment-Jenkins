pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        REPO_URL = 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
        DOCKER_IMAGE = 'simple-webapp'
        DOCKER_TAG = 'latest'
        CONTAINER_NAME = 'ecomm-webapp'
        PORT_MAP = '8084:80'
        EC2_IP = '44.204.140.25'
        DOCKER_DIR = '/home/ubuntu/Jenkins-Pipeline-Simple'
        move = 'ssh -o StrictHostKeyChecking=no'
    }

    stages {
        stage("Initial cleanup") {
          steps {
            dir("${WORKSPACE}") {
              deleteDir()
            }
          }
        }

        stage('Docker Environment Cleanup') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'rm -rf ${DOCKER_DIR}'"
                sh "${move} ubuntu@${EC2_IP} 'sudo docker rm -f ${CONTAINER_NAME}'"
                sh "${move} ubuntu@${EC2_IP} 'sudo docker rmi -f ${DOCKER_IMAGE}'"
                sh "${move} ubuntu@${EC2_IP} 'sudo docker rmi -f ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}'" }
            }
        }

        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: "${REPO_URL}"
            }
        }

        stage('Deploy Code to Webserver') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'git clone ${REPO_URL}'" }
            }
        }

        stage('Build Docker Image') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; sudo docker build -t ${DOCKER_IMAGE} .'" }
            }
        }

        stage('Run Docker Container') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; sudo docker run -d --name ${CONTAINER_NAME} -p ${PORT_MAP} ${DOCKER_IMAGE}'" }
            }
        }

        stage('Perform Unit Test') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; chmod +x unit-test.sh; sh unit-test.sh'" }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'docker login -u=${DOCKERHUB_USERNAME} -p=$"DOCKERHUB_PASSWORD"'"
                sh "${move} ubuntu@${EC2_IP} 'sudo docker push ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}'" }
            }
        }
    }
}
