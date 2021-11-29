# docker_dev
Define Docker image for multiplatform development needs, such as Kubernetes, k9s and more

# Deploy the docker image
```bash
docker build -t dev:latest -f Dockerfile . 
docker tag dev:latest ${DOCKERHUB_ID}/dev:latest
docker push ${DOCKERHUB_ID}/dev:latest 
```

# Define your environment
You can tweak [/docker-compose.yml](/docker-compose.yml) to mount env files and volume you'll use inside your dev environment.  
You'll likely need to define config env variables such as 
```bash
KUBECONFIG=conf
CLUSTER_NAME=
AWS_PROFILE=
```

# Run dev environment
```bash
docker-compose run dev
```