pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                echo 'Stage 1'
                checkout scmGit(branches: [[name: '*/dev']], extensions: [], userRemoteConfigs: [[credentialsId: 'pipeline', url: 'https://github.com/akashkr101/portfolio.git']])
            }
        }
        stage('directory info') {
            steps {
                echo 'Stage 2'
                sh 'ls'
                sh 'pwd'
            }
        }
        stage('npm install') {
            steps {
                echo 'Stage 3'
                sh 'npm install'
            }
        }
        stage('Clean Up') {
            steps {
                script {
                    echo 'Stage 4'
                    // This will run a shell script in the Jenkins pipeline
                    sh '''
                        # Get a list of all running containers
                        containers=$(docker ps -q)
                        # Check if there are any running containers
                        if [ -z "$containers" ]; then
                            echo "No containers are running."
                        else
                            echo "Stopping and removing all running containers."
                            # Stop all running containers
                            docker stop $containers
                            # Remove all stopped containers
                            docker rm $containers
                        fi
                    '''
                    sh '''
                        # Get a list of all Docker images
                        images=$(docker images -q)
                        # Check if there are any Docker images
                        if [ -z "$images" ]; then
                            echo "No Docker images found."
                        else
                            echo "Removing all Docker images."
                            # Remove all Docker images
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
        stage ('Push to Docker Hub') {
            steps {
                script {
                    echo 'stage 6'
                    sh 'docker tag portfolio-v2:latest akash63/portfolio-v2:4_sept'
                    // sh 'docker login'
                    sh 'docker push akash63/portfolio-v2:4_sept'
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Stage 7'
                    // Run a container from the built image
                    sh 'docker run -d -p 7000:80  portfolio-v2'
                    sh 'docker ps -a'
                }
            }
        }
        
      /*stage('kubernetes') {
            steps {
                script {
                    echo 'stage 9'
                    sh 'kubectl get pods'
                    sh 'kubectl get svc'
                    sh 'kubectl get deploy'
                }
            }
        }*/
    }

    /*post {
        always {
            script {
                emailext (
                    subject: "Jenkins Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' Completed",
                    body: """
                        Job Name: ${env.JOB_NAME}
                        Build Number: ${env.BUILD_NUMBER}
                        Build Status: ${currentBuild.currentResult}
                        Build URL: ${env.BUILD_URL}
                    """,
                    to: 'akashkumar.xda@gmail.com'
                )
            }
        }
    }*/
  post {
        success {
            echo "Pipeline success"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
