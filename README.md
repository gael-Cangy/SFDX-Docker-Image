
# SFDX-Docker-Image
Contains docker image that can be used on CDCI pipelines. It contains basic tooling like sfdx, sfdx-git-delta plugin and git 


# 1. Build Docker image
   - Go in to the repository after cloning it
  ```bash
      cd SFDX-Docker-Image
  ```
   - Build image that will be pushed to dockerhub with tag "latest"
   ```bash
      docker build -t debian-sfdx-image:latest .
   ```
   
# 2. Send Image to docker hub to be used by CDCI pipelines
   - Create a repository on docker hub with the following name: debian-sfdx-image
   - push the image previously created to the right dockerhub repository
   ```bash
     docker push <hub-user>/debian-sfdx-image:latest 
   ```
   
   
For those new to docker images follow this video to learn more. This is a great resource for beginners
https://www.youtube.com/watch?v=SnSH8Ht3MIc

Docker Documentation for image build:
   https://docs.docker.com/engine/reference/commandline/build/

Docker Documentation for pushing built image to docker hub:
   https://docs.docker.com/engine/reference/commandline/build/
