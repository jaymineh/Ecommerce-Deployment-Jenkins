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
        sshagent = 'webserver'
        ssh = 'ssh -o StrictHostKeyChecking=no'
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
                    sh "${ssh} ubuntu@${EC2_IP} 'rm -rf ${DOCKER_DIR}'"
                    sh "${ssh} ubuntu@${EC2_IP} 'docker rm -f ${CONTAINER_NAME}'"
                    sh "${ssh} ubuntu@${EC2_IP} 'docker rmi -f ${DOCKER_IMAGE}'"
                    sh "${ssh} ubuntu@${EC2_IP} 'docker rmi -f ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}'"
                }
            }
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
                sh "${ssh} ubuntu@${EC2_IP} 'git clone ${REPO_URL}'"
            }
            }
        }

        stage('Build Docker Image') {
            steps {
                sshagent (['webserver']) {
                sh "${ssh} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; docker build -t ${DOCKER_IMAGE} .'"
            }
            }
        }

        stage('Run Docker Container') {
            steps {
                sshagent (['webserver']) {
                sh "${ssh} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; docker run -d --name ${CONTAINER_NAME} -p ${PORT_MAPPING} ${DOCKER_IMAGE}'"
            }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                    sshagent (['webserver']) {
                    sh "${ssh} ubuntu@${EC2_IP} 'docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}'"
                    sh "${ssh} ubuntu@${EC2_IP} 'docker push ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}'"
                }
            }
        }
    }