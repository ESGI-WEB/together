FROM golang:alpine AS deps

WORKDIR /src/app

RUN apk --no-cache add ca-certificates

COPY go.mod go.sum ./
RUN go mod download

ENV PORT 8080
EXPOSE $PORT

FROM deps AS dev

RUN go install github.com/mitranim/gow@latest

CMD ["gow", "run", "."]

FROM deps AS prod

COPY *.go ./
RUN go build -o app

CMD ["./app"]
