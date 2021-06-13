FROM golang:alpine

COPY main.go /opt/
COPY go.mod /opt/
WORKDIR /opt
RUN go build -o server
