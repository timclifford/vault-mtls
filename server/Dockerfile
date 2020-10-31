FROM golang:1.15-alpine as build

RUN mkdir /app
WORKDIR /app

COPY . .
RUN ["go", "build", "-o", "build/server", "main.go"]


FROM alpine:3.12

WORKDIR /app

COPY --from=build /app/certs ./certs
COPY --from=build /app/build/server ./server
CMD ["/app/server"]
