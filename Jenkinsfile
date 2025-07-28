pipeline {
    agent any
    
    tools {
        maven 'maven'
        jdk 'jdk17'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        
        stage('get source code'){
            steps{
                git branch: 'main', url: 'https://github.com/IsharaFernando2018/FullStack-Blogging-App.git'
            }    
        }
        
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }

        
         stage('TRIVY FS SCAN') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }
        
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('SonarQube') {
                    sh ''' 
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectName=Blogging-app \
                    -Dsonar.projectKey=Blogging-app \
                    -Dsonar.sources=src \
                    -Dsonar.java.binaries=target/classes \
                    '''
                }
            }
        }
        
        
         stage('Publish Artifacts') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven-settings', jdk: 'jdk17', maven: 'maven', mavenSettingsConfig: '', traceability: true) {
                     sh "mvn deploy"
                }
            }
        }
        
        // stage("Docker Build & Tag"){
        //     steps{
        //         script{
        //             withDockerRegistry(credentialsId: 'docker') {
        //                 sh "docker build -t ferdi2018/bloggingapp:latest ."
        //                 }
        //         }
        //     }
        // }
        
        stage("Docker Build & Tag"){
    steps{
        script{
            echo "Current directory:"
            sh "pwd"
            echo "Files:"
            sh "ls -l"
            
            // Test docker connectivity
            sh "docker info"
            
            // Run docker build with output capture
            def output = sh(script: "docker build -t ferdi2018/bloggingapp:latest .", returnStdout: true).trim()
            echo "Docker Build output:\n${output}"
        }
    }
}

        
         stage('TRIVY Image SCAN') {
            steps {
                sh 'trivy image --format table --timeout 30m -o image.html ferdi2018/bloggingapp:latest'
            }
        }

        
        stage("Push Image"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker') {
                        sh "docker push ferdi2018/bloggingapp:latest"
                        }
                }
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        
    }
}

// pipeline { 
//     agent any
    
//     tools {
//         maven 'maven3'
//         jdk 'jdk17'
//     }

//     stages {
        
//         stage('Compile') {
//             steps {
//             sh  "mvn compile"
//             }
//         }
        
//         stage('Test') {
//             steps {
//                 sh "mvn test"
//             }
//         }
        
//         stage('Package') {
//             steps {
//                 sh "mvn package"
//             }
//         }
//     }
// }
