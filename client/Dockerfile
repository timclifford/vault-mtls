FROM golang:1.15-alpine as build

RUN mkdir /app
WORKDIR /app

COPY . .
RUN ["go", "build", "-o", "build/client", "main.go"]


FROM alpine:3.12

WORKDIR /app

COPY --from=build /app/build/client ./client
RUN mkdir /app/certs
CMD ["/app/client"]
