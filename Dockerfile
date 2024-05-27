FROM golang:alpine AS deps

WORKDIR /src/app

RUN apk --no-cache add ca-certificates

COPY back/go.mod back/go.sum ./
RUN go mod download

FROM deps AS dev

RUN go install github.com/mitranim/gow@latest

ENV PORT 8080
EXPOSE $PORT

CMD ["gow", "run", "."]

FROM deps AS builder

COPY ./back ./
RUN go build -o app

FROM debian:latest as flutterBuilder

#install all needed stuff
RUN apt-get update
RUN apt-get install -y curl git unzip

#define variables
ARG FLUTTER_VERSION=3.19.3
ARG FLUTTER_SDK_LOCATION=/usr/local/flutter
ARG APP_LOCATION=/src/app

#clone flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK_LOCATION
RUN cd $FLUTTER_SDK_LOCATION && git checkout tags/$FLUTTER_VERSION

#setup the flutter path as an environment variable
ENV PATH="$FLUTTER_SDK_LOCATION/bin:$FLUTTER_SDK_LOCATION/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

COPY ./front $APP_LOCATION
WORKDIR $APP_LOCATION

RUN flutter clean
RUN flutter pub get
RUN flutter build web

FROM alpine AS prod
WORKDIR /src/app

RUN apk --no-cache add ca-certificates

COPY --from=flutterBuilder /src/app/build /src/app/flutter_build
COPY --from=builder /src/app/app .

ENV PORT 8080
EXPOSE $PORT

CMD ["./app"]
