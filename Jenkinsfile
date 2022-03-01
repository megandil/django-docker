pipeline {
    environment {
        IMAGEN = "megandil/myapp"
        USUARIO = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Testear proyecto") {
            agent {
                docker { image 'python:3' }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'master',url:'https://github.com/megandil/django_tutorial.git'
                    }
                }
                stage('Install') {
                steps {
                    sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test'){
                steps {
                    sh 'python3 manage.py test'
                    }
                }
            }
        }
        stage("Subir imagen") {
            agent any
            stages {
                stage('Clone') {
                    steps {
                        git branch: "main", url: 'https://github.com/megandil/jenkins-docker'
                    }
                }
                stage('Build') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:$BUILD_NUMBER"
                        }
                    }
                }

                stage('Test') {
                    steps {
                        script {
                            docker.image("$IMAGEN:$BUILD_NUMBER").inside('-u root') {
                                sh 'apache2ctl -v'
                                }
                            }
                    }
                }
                
                stage('Deploy') {
                    steps {
                        script {
                            docker.withRegistry( '', USUARIO ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Clean Up') {
                    steps {
                        sh "docker rmi $IMAGEN:$BUILD_NUMBER"
                        }
                }
            }
        }
    }
}
