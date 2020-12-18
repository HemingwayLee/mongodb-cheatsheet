FROM python:3.8

RUN mkdir -p /home/app
WORKDIR /home/app
COPY . /home/app

ENV AWS_ACCESS_KEY_ID=DUMMYIDEXAMPLE
ENV AWS_SECRET_ACCESS_KEY=DUMMYEXAMPLEKEY

RUN pip3 install -r requirements.txt


