pipeline {
    agent any
    def envMap = [
        dev: [
            SONAR_PROJECT_KEY: 'your_project_dev',
            SONAR_ENVIRONMENT: 'dev'
        ],
        qa: [
            SONAR_PROJECT_KEY: 'your_project_qa',
            SONAR_ENVIRONMENT: 'qa'
        ]
    ]
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
            def selectedEnv = params.ENVIRONMENT ?: 'dev'  // Default to 'dev' if no parameter is passed
            def sonarProps = envMap[selectedEnv]

            echo "Running for environment: ${selectedEnv}"
            echo "Sonar Project Key: ${sonarProps.SONAR_PROJECT_KEY}"
            echo "Sonar Environment: ${sonarProps.SONAR_ENVIRONMENT}"

            // Set environment variables
            env.SONAR_PROJECT_KEY = sonarProps.SONAR_PROJECT_KEY
            env.SONAR_ENVIRONMENT = sonarProps.SONAR_ENVIRONMENT
        }

        stage('Run SonarQube Analysis') {
            withSonarQubeEnv('SonarQube') {
                sh """
                sonar-scanner \
                -Dsonar.projectKey=${env.SONAR_PROJECT_KEY} \
                -Dsonar.environment=${env.SONAR_ENVIRONMENT} \
                -Dsonar.sources=src
                """
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
