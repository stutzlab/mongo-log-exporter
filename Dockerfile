FROM golang:1.14.3-alpine3.11 AS BUILD

RUN apk add gcc build-base

WORKDIR /app

ADD /go.mod /app/
ADD /go.sum /app/

RUN go mod download -x

ADD / /app/

# RUN go test -v

RUN go build -v -o /bin/mongos-exporter
RUN chmod +x /bin/mongos-exporter



FROM alpine:3.12.0

ENV MONGODB_URL ''

ADD /startup.sh /
COPY --from=BUILD /bin/mongos-exporter /bin/

EXPOSE 8880

CMD [ "/startup.sh" ]

