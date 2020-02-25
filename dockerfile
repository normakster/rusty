FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y curl apt-transport-https ca-certificates
RUN apt-get install -y gnupg-agent software-properties-common
RUN apt-get install -y python3.6 vim git make screen

#RUN apt-get update
#COPY ./requirements.txt /
#RUN apt-get install -yr /requirements.txt
#RUN sed 's/#.*//' requirements.txt | xargs apt-get install -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

COPY ./rusty.sh rusty.sh
RUN chmod +x rusty.sh

#VOLUME /rusty
#VOLUME /var/run/docker.sock

ENTRYPOINT ["bash"]
