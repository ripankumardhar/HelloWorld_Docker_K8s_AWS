# HelloWorld_Docker_K8s_AWS


node{
    
    
    stage('SCM Checkout'){
        git credentialsId: 'GIT_credential', url: 'https://github.com/ripankumardhar/HelloWorld_Docker_K8s_AWS.git',branch: 'main'
    }
   
    stage(" Maven Clean Package"){
      def mavenHome =  tool name: "Maven-3.8.3", type: "maven"
      def mavenCMD = "${mavenHome}/bin/mvn"
      sh "${mavenCMD} clean package"
      
    } 
    
    stage('Build Docker Image'){
        sh 'docker build -t ridh19/helloworldproject .'
    }
    
    stage('Push Docker Image'){
        
        //sh('docker -u $EXAMPLE_CREDS_USR:$EXAMPLE_CREDS_PSW https://hub.docker.com')
        withCredentials([string(credentialsId: 'D_H_C', variable: 'D_H_C')]) {
          sh 'docker login -u ridh19 -p ${D_H_C}'
        }
        sh 'docker push ridh19/helloworldproject'
     }
       
      
     stage("Deploy To Kuberates Cluster"){
       kubernetesDeploy(
         configs: 'javawebapp-deployment.yml', 
         kubeconfigId: 'k8_cluster_config',
         //enableConfigSubstitution: true
        )
     }
     
}
