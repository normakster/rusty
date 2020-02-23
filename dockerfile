FROM ubuntu:18.04
#FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y python3.6 vim curl git make screen apt-transport-https ca-certificates gnupg-agent software-properties-common
#RUN curl https://bootstrap.pypa.io/get-pip.py | python3.6
#RUN python3.6 -m pip install awscli
#RUN apt-get install -y curl python3.6 git
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

COPY ./rusty.sh rusty.sh
RUN chmod +x rusty.sh

#VOLUME /rusty
#VOLUME /var/run/docker.sock

ENTRYPOINT ["bash"]
