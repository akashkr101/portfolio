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
        stage('npm install') {
            steps {
                sh 'npm install'
            }
        }        
        stage('Build') {
            steps {
                sh 'npm run build --configuration production'
                sh 'npm run test --watch=false --code-coverage'
            }
        }
        stage('SonarQube') {
            steps {
                withSonarQubeEnv('Sonarqube') {
                    sh 'sonar-scanner'
                }
            }
        }
        /*stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }*/
        stage('Clean Up') {
            steps {
                script {
                    sh '''
                        # Get a list of all running containers
                        containers=$(docker ps --filter "name=portfolio" -q)
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
        stage ('Push to Docker Hub') {
            steps {
                script {
                    echo 'stage 6'
                    //sh 'docker tag portfolio-v2:latest akash63/portfolio-v2:4_sept'
                    //sh 'docker login'
                    //sh 'docker push akash63/portfolio-v2:4_sept'
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
        
        /*stage("start minikube") {
            steps {
                echo "stage 8"
                sh 'minikube delete'
                sh 'minikube start'
            }
        }*/
        
      /*stage('kubernetes') {
            steps {
                script {
                    echo 'stage 8'
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
