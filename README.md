# HelloWorld_Docker_K8s_AWS

## Pre - requisites

### Install and set up Jenkins
- Install Java
- Install and set up Jenkins from .war file. Add secret key for first time use

### Set up Docker in Jenkins Server
- Install Docker
- Add Jenkins User to Docker Group
- Restart Jenkins

### Set Up Kubernetes Cluster
- Create Ubantu machines in AWS EC2 instances - Master and Worker machines
- Install Docker, Kubectl
- Start Kubelet
- In Master node copy config file in $HOME/kube/config
- In worker nodes copy kubeadm join token and execute  worker nodes to join into cluster

### Set Up Jenkins server to deploy zpplications into kubernetes cluster using Kubernetes Continues Deploy Plugin
- Add  Kubernetes Continues Deploy Plugin to Jenkins
- Add Kube config details in Jenkins Credentials
- Use KubernetesDeploy in pipeline script

### Pipeline Script in Jenkins

```bash

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
         enableConfigSubstitution: true
        )
     }
   }

```
