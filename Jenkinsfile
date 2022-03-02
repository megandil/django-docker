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
                        }
                }
                stage('Correo') {
                    steps {
                            emailext body: 'Pipeline ejecutado!',
                            subject: 'Jenkins Daniel Mesa',
                            to: 'danimesamejias@gmail.com'
                        }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials: ['jenkins']) {
                            sh '''
                            scp docker-compose.yaml debian@tesla.danielmesa.site
                            ssh debian@tesla.danielmesa.site docker-compose down
                            ssh debian@tesla.danielmesa.site docker rmi $(docker images |egrep bookmedik| awk '{print $1,$2}')
                            ssh debian@tesla.danielmesa.site docker-compose up -d
                            '''
                        }
                    }
                }
            }
        }
    }
}
