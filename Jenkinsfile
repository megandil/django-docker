pipeline {
    environment {
        IMAGEN = "megandil/myapp"
        USUARIO = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Testear proyecto") {
            agent {
                docker { image 'python:3' 
                args '-u root:root'}
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'main',url:'https://github.com/megandil/django-docker'
                    }
                }
                stage('Install') {
                steps {
                    sh 'cd build/django_tutorial && pip install -r requirements.txt'
                    }
                }
                stage('Cambio Settings') {
                steps {
                    sh 'cp settings_temp.py build/django_tutorial/django_tutorial/settings.py'
                    }
                }
                stage('Test'){
                steps {
                    sh 'cd build/django_tutorial && python3 manage.py test'
                    }
                }
            }
        }
        stage("Subir imagen") {
            agent any
            stages {
                stage('Clone') {
                    steps {
                        git branch: "main", url: 'https://github.com/megandil/django-docker'
                    }
                }
                stage('Build') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:$BUILD_NUMBER"
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
                        sh "echo BUILD_NUMBER=$BUILD_NUMBER > .env"
                        }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials: ['jenkins']) {
                            sh '''
                            scp docker-compose.yaml debian@tesla.danielmesa.site:
                            scp .env debian@tesla.danielmesa.site:
                            ssh debian@tesla.danielmesa.site docker-compose down
                            ssh debian@tesla.danielmesa.site docker images -a | grep "megandil/myapp" | awk '{print $3}' | xargs docker rmi
                            ssh debian@tesla.danielmesa.site docker-compose up -d
                            '''
                        }
                    }
                }
                stage('Correo') {
                    steps {
                            emailext body: 'Pipeline ejecutado!',
                            subject: 'Jenkins Daniel Mesa',
                            to: 'danimesamejias@gmail.com'
                        }
                }
            }
        }
    }
}
