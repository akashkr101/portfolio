pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                echo 'Stage 1--'
                checkout scmGit(branches: [[name: '*/dev']], extensions: [], userRemoteConfigs: [[credentialsId: 'pipeline', url: 'https://github.com/akashkr101/portfolio.git']])
            }
        }
        stage('check') {
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
        stage('serve') {
            steps {
                echo 'Stage 4'
                /*sh 'ng build --configuration production'*/
                /* sh 'echo 'your_password' | sudo -S pm2 serve ' ' 4200' */
                /* sh 'pm2 serve " " 4200' */
                /*sh 'ng serve --port 4200 &'*/
            }
        }
        /*
        stage('Monitor') {
            steps {
                sh 'cd /var/lib/jenkins/workspace/pipeline'
                sh 'pm2 serve " " 4200'
                sh 'pm2 list'
                sh 'pm2 monit'
                sh 'pm2 monitor'
                sh 'echo "monitoring" '
            }
        }*/
        stage('Clean Up') {
            steps {
                script {
                    echo 'Stage 5'
                    // Stop and remove container
                    /*sh 'docker rm -f $(docker ps -aq)'
                    sh 'docker rmi -f $(docker images -aq)'
                    sh 'docker ps -a'
                    sh 'docker images'*/
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
                    echo 'Stage 6'
                    sh 'docker build -t portfolio .'
                    sh 'docker images'
                }
            }
        }
        stage ('Push to Docker Hub') {
            steps {
                script {
                echo 'stage 8'
                    /*echo 'stage 7'
                    sh 'docker tag portfolio akash63/portfolio-v2:latest'
                    sh 'docker push akash63/portfolio-v2:latest'*/
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    echo 'Stage 8'
                    // Run a container from the built image
                    sh 'docker run -d -p 7000:80  portfolio'
                    sh 'docker ps -a'
                }
            }
        }
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
}
