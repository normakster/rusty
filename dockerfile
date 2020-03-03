FROM ubuntu:18.04

# Maybe add RUN apt-get install -y curl

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  python3.8 \
  python3-distutils \
  curl \
  vim \
  git \
  make \
  screen \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose

COPY ./requirements.txt /
RUN pip install -r /requirements.txt

COPY ./rusty.sh rusty.sh
RUN chmod +x rusty.sh


ENTRYPOINT ["/bin/bash"]
