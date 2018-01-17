# docker-lambda-canvas


thanks to https://github.com/navihtot/node-caman-aws-lambda/blob/master/how-to.md

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
  - docker pull piercus/lambda-canvas
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