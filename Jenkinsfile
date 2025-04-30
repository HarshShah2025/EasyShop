pipeline {
    agent any
    
    stages {
        stage("clean workspace") {
            steps {
                echo "workspacde clean ..."
            }
        }
        stage("code clone") {
            steps {
                git url:"https://github.com/learnersubha/EasyShop.git", branch: "main"
            }
        }
        stage("code build parallely") {
            parallel {
                stage("app image build") {
                    steps {
                        sh "docker build -t easyapp ."
                    }
                }
                stage("migration image build") {
                    steps {
                    sh "docker build -t easyapp-migration -f scripts/Docker-migration ."
                    }
                }
                
            }
        }
        stage("trivy scan") {
            steps {
                 sh "trivy fs . -o result.json"
            }
        }
        stage("image push") {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "dockerhubaccess",
                    passwordVariable: "dockerhubpass",
                    usernameVariable: "dockerhubuser"
                )]) {
                    sh """
                          echo "$dockerhubpass" | docker login -u "$dockerhubuser" --password-stdin
                          docker image tag easyapp  ${env.dockerhubuser}/easyapp:latest
                          docker push ${env.dockerhubuser}/easyapp:latest
                          docker image tag easyapp-migration ${env.dockerhubuser}/easyapp-migration:latest
                          docker push ${env.dockerhubuser}/easyapp-migration:latest
                    """
                }
            }
        }
        
        
    }
}
