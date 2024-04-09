FROM golang:alpine

WORKDIR /src/app

RUN apk --no-cache add ca-certificates

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN go build -o app

ENV PORT 8080
EXPOSE $PORT

CMD ["./app"]
