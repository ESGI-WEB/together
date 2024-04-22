FROM golang:alpine

WORKDIR /src/app

RUN apk --no-cache add ca-certificates
RUN go install github.com/mitranim/gow@latest

COPY go.mod go.sum ./
RUN go mod download

ENV PORT 8080
EXPOSE $PORT

CMD ["gow", "run", "."]
