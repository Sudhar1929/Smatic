pipeline {
    agent any

    environment {
        APP_NAME = 'node-api'
        REGISTRY = 'artifactory.smatics.com'
        IMAGE = "${REGISTRY}/${APP_NAME}:${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE} ."
            }
        }

        // pushing to hub with creds defined in jenkins secret
        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: docker-creds',
                    usernameVariable: 'DOCKER-USER',
                    passwordVariable: 'DOCKER-PASS'
                )]) {
                    sh "echo $DOCKER-PASS | docker login ${REGISTRY} -u $DOCKER-USER --password-stdin"
                    sh "docker push ${IMAGE}"
                    sh "docker logout ${REGISTRY}"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f kubernetes/deployment.yaml'
                sh 'kubectl apply -f kubernetes/service.yaml'
                sh 'kubectl apply -f kubernetes/ingres.yaml'
            }
        }

    }

    post {
        success {
            echo "build ${env.BUILD_NUMBER} deployed"
        }
        failure {
            echo "${env.BUILD_NUMBER} has failed. Check the logs on what went wrong"
        }
    }
}
