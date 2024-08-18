# Automating Deployment Of An E-Commerce Website

**Step 1 - Setup Infrastructure**
---

- Provision 2 EC2 instances; one for Jenkins (CI server) and the other for hosting the webapp (Webserver).

- Setup Jenkins on the Jenkins server and install necessary plugins.

- Configure webhook b/w GitHub and Jenkins and test to confirm it is working as expected.

- Setup ssh-agent to allow seamless connection b/w the Jenkins server and Webserver.


**Step 2 - Begin Jenkinsfile**
---

- Use a simple Jenkinsfile to test if the webhook is working as expected. It can also be used as a template which can be expanded with various build steps. Use this sample below:

```
pipeline {
    agent any

  stages {
    stage("Initial cleanup"){
      steps {
        dir("${WORKSPACE}") {
          deleteDir()
        }
      }
    }
    
    stage('Build') {
      steps {
        script {
          sh 'echo "Building Stage"'
        }
      }
    }
  }
}
```

- After the Jenkinsfile has been confirmed to be working, setup environment variables in the Jenkinsfile that would be used instead of hardcoding values. See sample below:

```
pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
        REPO_URL = 'https://github.com/jaymineh/Jenkins-Pipeline-Simple.git'
        DOCKER_IMAGE = 'simple-webapp'
        DOCKER_TAG = '0.1-alpha'
        CONTAINER_NAME = 'ecomm-webapp'
        PORT_MAP = '8084:80'
        EC2_IP = '44.204.140.25'
        DOCKER_DIR = '/home/ubuntu/Jenkins-Pipeline-Simple'
        move = 'ssh -o StrictHostKeyChecking=no'
    }
```

- Create a Dockerfile which would be used to build the app. See Dockerfile below:

```
# Use an official nginx image as the base image
FROM nginx:alpine

# Copy the HTML file to the nginx html directory
COPY webapp.html /usr/share/nginx/html/webapp.html

# Copy a custom nginx configuration file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
```

- Run the stage below to build the Dockerfile. Note that the `webapp.html` and `nginx.conf` files must have been checkout to the repository and downloaded onto the webserver.

```
stage('Build Docker Image') {
            steps {
                sshagent (['webserver']) {
                sh "${move} ubuntu@${EC2_IP} 'cd ${DOCKER_DIR}; sudo docker build -t ${DOCKER_IMAGE} .'" }
            }
        }
```