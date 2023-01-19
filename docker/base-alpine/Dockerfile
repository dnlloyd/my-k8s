FROM alpine:3.15

ARG TAG=0.1.0

LABEL org.opencontainers.image.source https://github.com/dnlloyd/my-k8s/tree/master/docker/base-alpine
LABEL org.opencontainers.image.registry 458891109543.dkr.ecr.us-east-1.amazonaws.com/base-alpine:$TAG

# Install timezones
RUN apk add --no-cache tzdata
