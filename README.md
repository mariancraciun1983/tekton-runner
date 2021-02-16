# Tekton Runner

Various dockerized tools in a single image useful during Tekton Tasks. The following are included:
 - Kaniko executor
 - Kaniko warmer
 - kustomize
 - kubectl

## Building

```bash
docker build \
    --tag mariancraciun/tekton-runner:latest .
```

## Running


```bash
docker run -it --rm \
    mariancraciun/tekton-runner:latest \
    /kaniko/warmer \
    --cache-dir=/workspace/source/.buildcache/ \
    --image=python:3.8.7-slim-buster \
    --image=nginx:1.19.6-alpine \
    --verbosity=debug
docker run -it --rm \
    mariancraciun/tekton-runner:latest \
    /kaniko/executor --help
```
