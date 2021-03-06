# docker-lambda-canvas

A Docker with :
* amazon lambda environment
* node 6
* npm
* Canvas (canvas binaries are inside `/var/task/canvas` folder)

## Usage 

To use it just do 

### Step 1: Create a docker to deploy your app

in `Dockerfile` do

```
FROM piercus/lambda-canvas:default

ADD .
RUN npm install 
RUN serverless deploy
```




thanks to https://github.com/navihtot/node-caman-aws-lambda/blob/master/how-to.md

## Build

```bash
./build.sh

docker build -f Dockerfile.default -t piercus/lambda-canvas:default .
docker build -f Dockerfile.opencv -t piercus/lambda-canvas:opencv .

docker push piercus/lambda-canvas:default
docker push piercus/lambda-canvas:opencv
```

## How to use it with travis

this is intended to be used inside a lambda function with a docker build process


in `.travis.yml`
```yml
sudo: required
language: node_js
node_js:
  - 6
services:
  - docker

install:
  - docker pull piercus/lambda-canvas:default
  - ID_RSA=$(cat ~/.ssh/id_rsa)
  - docker build -t myProject:root -f docker/myProject.root \
    --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    --build-arg AWS_REGION=$AWS_REGION \
    --build-arg ID_RSA="$ID_RSA" .
  
script:
  - docker build -f docker/myProject.test .

deploy:
  skip_cleanup: true
  provider: script
  script:
    - docker build -f docker/Dockerfile.deploy .
  on:
    branch: develop
```

see examples folder to see examples for myProject.root, myProject.test and myProject.deploy