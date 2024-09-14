pipeline {
    agent any
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'qa'],
            description: 'Select the environment to run the build'
        )
    }
    environment {
        // Define a variable to control the environment
        ENVIRONMENT = "${params.ENVIRONMENT}"
    }
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
        stage('Prepare SonarQube Analysis') {
            steps {
                script {
                    sh 'sonar-scanner --version'
                    if (ENVIRONMENT == 'dev') {
                        env.SONAR_PROJECT_KEY = 'your_project_dev'
                        env.SONAR_ENVIRONMENT = 'dev'
                    } else if (ENVIRONMENT == 'qa') {
                        env.SONAR_PROJECT_KEY = 'your_project_qa'
                        env.SONAR_ENVIRONMENT = 'qa'
                    } else {
                        error("Unknown environment: ${ENVIRONMENT}")
                    }

                    echo "Running SonarQube analysis for environment: ${ENVIRONMENT}"
                }
            }
        }
        stage('Verify sonar-scanner') {
            steps {
                echo 'new stage'
                sh 'sonar-scanner --version'  // Check if sonar-scanner is available
            }
        }
        stage('Run SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarQube') { // Name of your SonarQube server configured in Jenkins
                    sh '''
                    echo "Running sonar-scanner with the following parameters:"
                    echo "sonar.projectKey=${SONAR_PROJECT_KEY}"
                    echo "sonar.environment=${SONAR_ENVIRONMENT}"
                    sonar-scanner \
                      -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                      -Dsonar.environment=${SONAR_ENVIRONMENT} \
                      -Dsonar.sources=src
                    '''
                }
            }
        }
        /*
        stage('SonarQube') {
            steps {
                withSonarQubeEnv('Sonarqube') {
                    sh 'sonar-scanner'
                }
            }
        }*/
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
                    sh 'docker build -t portfolio-v2 .'
                    sh 'docker images'
                }
            }
        }
        /*stage ('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker tag portfolio-v2:latest akash63/portfolio-v2:sept'
                    sh 'docker push akash63/portfolio-v2:sept'
                }
            }
        }*/
        stage('Run Docker Container') {
            steps {
                script {
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
