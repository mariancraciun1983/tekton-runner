FROM gcr.io/kaniko-project/warmer:v1.3.0 as warmer
FROM gcr.io/kaniko-project/executor:v0.24.0 as executor

FROM alpine:3.13.1

RUN apk --no-cache add \
    bash \
    curl \
    git \
    jq

# # kustomize
ENV KUSTOMIZE_VERSION=3.10.0
RUN curl -sLf "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" -o kustomize.tar.gz\
    && tar xf kustomize.tar.gz \
    && mv kustomize /usr/bin \
    && chmod +x /usr/bin/kustomize \
    && rm -rf kustomize*

# kubectl
ENV KUBECTL_VERSION=1.20.2
RUN curl -sLf "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /usr/bin/kubectl


# Kaniko
COPY --from=warmer /kaniko/warmer /kaniko/warmer
COPY --from=executor /kaniko/executor /kaniko/executor
COPY --from=executor /kaniko/ssl/certs/ /kaniko/ssl/certs/
COPY --from=executor /kaniko/.docker /kaniko/.docker
COPY --from=executor /etc/nsswitch.conf /etc/nsswitch.conf

ENV HOME /root
ENV USER root
ENV SSL_CERT_DIR=/kaniko/ssl/certs
ENV DOCKER_CONFIG /kaniko/.docker/

ENV PATH $PATH:/kaniko

WORKDIR /workspace