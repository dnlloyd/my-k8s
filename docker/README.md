# Docker

## Build

```
docker build -t flask-app .
```

## Run

```
docker run -dit --name flask-app -p 80:8000 flask-app
```

## Verify

http://127.0.0.1

# Troubleshoot

```
docker exec -it flask-app sh
```
