FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Heavy depedencies
RUN apt-get update && \
    apt-get install -y cmake build-essential git python3 python3-distutils python3-pip python3-venv \
    curl wget vim unzip

RUN apt-get update && \
    apt-get install -y tzdata direnv snapd iputils-ping sudo

WORKDIR /opt

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws

# DOCKER
RUN apt-get update && \
    curl -sSL https://get.docker.com/ | sh

# DOCKER COMPOSE
RUN curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# KUBECTL
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Get go from its Docker container, needed to install k9s
COPY --from=golang:1.17.3 /usr/local/go/ /usr/local/go/
 
ENV PATH="/usr/local/go/bin:${PATH}"

# Install k9s
RUN git clone https://github.com/derailed/k9s.git && \
    cd k9s && \
    make build && \
    mv ./execs/k9s /usr/local/bin/k9s && \
    cd .. && \
    rm -rf k9s

ENV PATH="/usr/local/bin:${PATH}"

#    ./execs/k9s && \

# Doesn't work, hint is because of 32bit docker image. 
# COPY --from=derailed/k9s:latest /bin/k9s /bin/k9s
# Add k9s to env
# ENV PATH="/bin/:${PATH}"

# KOMPOSE

RUN curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.0/kompose-linux-amd64 -o kompose && \
    chmod +x kompose && \
    mv ./kompose /usr/local/bin/kompose

# Get brew
# COPY --from=homebrew/brew:latest /home/linuxbrew/ /opt/linuxbrew
# add brew
# ENV PATH="/opt/linuxbrew/.linuxbrew/bin:/opt/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN pip3 install --upgrade pip

CMD /bin/bash
