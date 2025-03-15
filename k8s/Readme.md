How to set-up the 3 tier (Next.js 14, TypeScript, and MongoDB) easy-shop app and deploy in Kind cluster.

Step:-1

Create an EC2 instance and connect through SSH.
Now install the required tools 
Docker (sudo apt-get update && sudo apt-get install docker.io then provide your login user docker folder permission and restart docker [sudo usermod -aG docker $USER && newgrp docker])
Kind (https://kind.sigs.k8s.io/docs/user/quick-start/) ## through this link you can install kind for Linux, macOS, windows also.
kubectl (https://kubernetes.io/docs/tasks/tools/) ## through this link you can install kubectl for Linux, macOS, windows also.

Step:-2

clone the repository with git clone https://github.com/learnersubha/EasyShop.git
and enter into the Easyshop directory --> cd Easyshop

Step:-3

Push the migration image and app image in docker-hub
For image push in docker first need to login into docker-hub.
docker login -u <docker-hub username> and press enter, Then ask for password give the personal access token as password
( First open docker-hub --> click on docker-hub profile --> click on account setting --> click on personal access token --> generaate a new token )

First build the app image then build the migration image (both docker file available in this repository)
docker build -t docker-hub username/easyshop-image .  ---> docker push docker-hub username/easyshop-image.
docker build -t docker-hub username/migration-image -f scripts/Dockerfile.migration .   ---> docker push docker-hub username/migration-image

Step:-4

cluster setup
kind create cluster --config cluster.yaml --name easyshop  <https://github.com/learnersubha/EasyShop/blob/main/k8s/cluster.yaml>

Step:-5

Namespace Create
kubectl apply -f namespace.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/namespace.yaml>

Step:-6

Create and Claim Persistent Volume
kubectl apply -f mongodb-pv.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/mongodb-pv.yaml>
kubectl apply -f mongodb-pvc.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/mongodb-pvc.yaml>

step:-7

setup configmap

apiVersion: v1
kind: ConfigMap
metadata:
  name: mongodb-config
  namespace: easyshop-ns
data:
  MONGODB_URI: "mongodb://mongodb-service:27017/easyshop"
  NODE_ENV: "production"
  NEXT_PUBLIC_API_URL: "http://34.242.255.167/api"  # Replace with your YOUR_EC2_PUBLIC_IP
  NEXTAUTH_URL: "http://34.242.255.167"             # Replace with your YOUR_EC2_PUBLIC_IP
  NEXTAUTH_SECRET: "8ebd611ed5b60bde887fbc88814e4274141a767d8cc527fa296ebc840247c330"  ## Create your Own NEXTAUTH_SECRET secret
  JWT_SECRET: "wZQ9gUk5vNcVTqrVhuoqe54Y3eifR22HWEU46cfIem0="   ## Create your Own JWT_SECRET secret

  For NEXTAUTH_SECRET use : openssl rand -hex 32
  For  JWT_SECRET use : openssl rand -base64 32

  kubectl apply -f configmap.yaml

Step:-8

Create the secret and setup
kubectl apply -f secret.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/secret.yaml>

step:-9

mongodb deployment
kubectl apply -f mongodb-service.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/mongodb-service>
kubectl apply -f statefulset.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/statefulset>

Step:-10

Deployment of easyshop
kubectl apply -f easyshop-deployment.yaml <https://github.com/learnersubha/EasyShop/blob/main/k8s/easyshop-deploymant.yaml>
kubectl apply -f easyshop-service.yaml  <https://github.com/learnersubha/EasyShop/blob/main/k8s/easyshop-service.yaml>

Step:-11

Install nginx Ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

for check the nginx pods : kubectl get pods -n ingress-nginx

Step:12

Deploy the Ingress and HPA 
kubectl apply -f easyshop-ingress.yaml   <https://github.com/learnersubha/EasyShop/blob/main/k8s/easyshop-ingress.yaml>
kubectl apply -f easyshop-hpa.yaml   <https://github.com/learnersubha/EasyShop/blob/main/k8s/easyshop-hpa.yaml>

Step:-13
Upgrade the migration Job

apiVersion: batch/v1
kind: Job

metadata:
  name: easyshop-migration
  namespace: easyshop-ns

spec:
  template:
    spec:
      containers:
      - name: migration
        image: learnersubha/easyshop-app-migration:latest
        imagePullPolicy: Always
        env:
        - name: MONGODB_URI
          value: "mongodb://mongodb-service:27017/easyshop"
      restartPolicy: OnFailure
   
  kubectl apply -f migration.yaml   <https://github.com/learnersubha/EasyShop/blob/main/k8s/migration.yaml>

































  




















