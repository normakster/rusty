FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
RUN apt-get install -y python3.8
RUN apt-get install -y python3-distutils
RUN apt-get install -y curl vim git make screen

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.8
RUN pip install uvicorn fastapi python-multipart pyjwt passlib[bcrypt]
COPY ./requirements.txt /
RUN pip install -r /requirements.txt
#RUN pip install uvicorn fastapi python-multipart pyjwt passlib[bcrypt]

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

COPY ./rusty.sh rusty.sh
RUN chmod +x rusty.sh

#VOLUME /rusty
#VOLUME /var/run/docker.sock

ENTRYPOINT ["bash"]
