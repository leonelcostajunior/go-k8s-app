pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "leonelpaiva"
        DOCKER_IMAGE = "go-k8s-app"
        IMAGE_TAG = "v1.${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKERHUB_USER/$DOCKER_IMAGE:$IMAGE_TAG ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-pass', variable: 'DOCKERHUB_PASS')]) {
                    sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
                }
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push $DOCKERHUB_USER/$DOCKER_IMAGE:$IMAGE_TAG"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl set image deployment/go-k8s-app go-k8s-app=$DOCKERHUB_USER/$DOCKER_IMAGE:$IMAGE_TAG"
                sh "kubectl rollout status deployment/go-k8s-app"
            }
        }
    }
}
