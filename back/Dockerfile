FROM golang:alpine AS deps

WORKDIR /src/app

RUN apk --no-cache add ca-certificates

COPY go.mod go.sum ./
RUN go mod download

FROM deps AS dev

RUN go install github.com/mitranim/gow@latest

ENV PORT 8080
EXPOSE $PORT

CMD ["gow", "run", "."]

FROM deps AS builder

COPY . ./
RUN go build -o app

FROM alpine AS prod

WORKDIR /src/app
RUN apk --no-cache add ca-certificates

COPY --from=builder /src/app/app .

ENV PORT 8080
EXPOSE $PORT

CMD ["./app"]
