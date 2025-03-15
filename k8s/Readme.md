How to set-up the 3 tier (Next.js 14, TypeScript, and MongoDB) easy-shop app and deploy in Kind cluster.

Step:-1

Create an EC2 instance and connect through SSH.
Now install the required tools 
Docker (sudo apt-get update && sudo apt-get install docker.io then provide your login user docker folder permission and restart docker [sudo usermod -aG docker $USER && newgrp docker])
Kind (https://kind.sigs.k8s.io/docs/user/quick-start/) ## through this link you can install kind for Linux, macOS, windows also.
kubectl (https://kubernetes.io/docs/tasks/tools/) ## through this link you can install kubectl for Linux, macOS, windows also.

Step:-2

Push the migration image and app image in docker-hub
For image push in docker first need to login into docker-hub.
docker login -u <docker-hub username> and press enter, Then ask for password give the personal access token as password
(First open docker-hub )
