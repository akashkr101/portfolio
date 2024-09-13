pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/dev']], extensions: [], userRemoteConfigs: [[credentialsId: 'pipeline', url: 'https://github.com/akashkr101/portfolio.git']])
            }
        }
        stage('directory info') {
            steps {
                sh 'ls'
                sh 'pwd'
            }
        }
        stage('Install & Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('SonarQube') {
            steps {
                withSonarQubeEnv('Sonarqube') {
                    sh 'sonar-scanner'
                }
            }
        }
        stage('Clean Up') {
            steps {
                script {
                    sh '''
                        # Get a list of all running containers
                        containers=$(docker ps --filter "ancestor=portfolio-v2" -q)
                        # Check if there are any running containers
                        if [ -z "$containers" ]; then
                            echo "No 'portfolio' are running."
                        else
                            echo "Stopping and removing portfolio containers."
                            docker stop $containers
                            docker rm $containers
                        fi
                    '''
                    sh '''
                        # Get a list of all Docker images
                        images=$(docker images --filter "reference=*portfolio*" -q)
                        # Check if there are any Docker images
                        if [ -z "$images" ]; then
                            echo "No 'portfolio' images found."
                        else
                            echo "Removing 'portfolio' images."
                            docker rmi -f $images
                        fi
                    '''
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Stage 5'
                    sh 'docker build -t portfolio-v2 .'
                    sh 'docker images'
                }
            }
        }
        /*stage ('Push to Docker Hub') {
            steps {
                script {
                    echo 'stage 6'
                    sh 'docker tag portfolio-v2:latest akash63/portfolio-v2:sept'
                    sh 'docker login $DOCKERHUB_CREDENTIALS'
                    sh 'docker push akash63/portfolio-v2:sept'
                }
            }
        }*/
        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Stage 7'
                    sh 'docker run -d -p 7000:80  portfolio-v2'
                    sh 'docker ps -a'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline success"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
