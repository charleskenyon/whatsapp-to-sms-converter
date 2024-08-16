#!/bin/bash

REGION="eu-west-2"
REPO_NAME="whatsapp-to-sms-converter"
IMAGE_NAME=$REPO_NAME
TAG="latest"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text) 
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}"

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

docker build -t $IMAGE_NAME .

docker tag $IMAGE_NAME:latest $ECR_REPO_URL:$TAG

docker push $ECR_REPO_URL:$TAG

echo "Docker image pushed to ECR: ${ECR_REPO_URL}:${TAG}"
