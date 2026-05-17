pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "791358130074"
        AWS_REGION = "ap-south-1"
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('AWS ECR Login') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}"
                }
            }
        }
        
        stage('Build & Push Frontend') {
            steps {
                script {
                    sh '''
                        docker build \\
                          --build-arg REACT_APP_AUTH_API_URL=/api/auth \\
                          --build-arg REACT_APP_STREAMING_API_URL=/api/streaming \\
                          --build-arg REACT_APP_STREAMING_PUBLIC_URL=/api/streaming \\
                          --build-arg REACT_APP_ADMIN_API_URL=/api/admin \\
                          --build-arg REACT_APP_CHAT_API_URL=/api/chat \\
                          --build-arg REACT_APP_CHAT_SOCKET_URL=/ \\
                          -t streaming-frontend ./frontend
                    '''
                    sh "docker tag streaming-frontend:latest ${ECR_URI}/streaming-frontend:latest"
                    sh "docker push ${ECR_URI}/streaming-frontend:latest"
                }
            }
        }
        
        stage('Build & Push Auth Service') {
            steps {
                script {
                    sh "docker build -t streaming-auth ./backend/authService"
                    sh "docker tag streaming-auth:latest ${ECR_URI}/streaming-auth:latest"
                    sh "docker push ${ECR_URI}/streaming-auth:latest"
                }
            }
        }
        
        stage('Build & Push Admin Service') {
            steps {
                script {
                    sh "docker build -f ./backend/adminService/Dockerfile -t streaming-admin ./backend"
                    sh "docker tag streaming-admin:latest ${ECR_URI}/streaming-admin:latest"
                    sh "docker push ${ECR_URI}/streaming-admin:latest"
                }
            }
        }

        stage('Build & Push Chat Service') {
            steps {
                script {
                    sh "docker build -f ./backend/chatService/Dockerfile -t streaming-chat ./backend"
                    sh "docker tag streaming-chat:latest ${ECR_URI}/streaming-chat:latest"
                    sh "docker push ${ECR_URI}/streaming-chat:latest"
                }
            }
        }

        stage('Build & Push Streaming Service') {
            steps {
                script {
                    sh "docker build -f ./backend/streamingService/Dockerfile -t streaming-streaming ./backend"
                    sh "docker tag streaming-streaming:latest ${ECR_URI}/streaming-streaming:latest"
                    sh "docker push ${ECR_URI}/streaming-streaming:latest"
                }
            }
        }
    }
}
