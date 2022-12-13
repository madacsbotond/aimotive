FROM python:3.11-alpine

RUN apk add curl git

RUN pip install flask redis

COPY app/* /

CMD [ "sleep", "infinity" ]