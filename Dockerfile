FROM golang:1.14.6-alpine3.12 as builder

WORKDIR /app

COPY go.mod go.sum /app/

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/bucketeer gitlab.com/idoko/bucketeer

FROM alpine

RUN apk add --no-cache ca-certificates && update-ca-certificates

COPY --from=builder /app /usr/bin/bucketeer

EXPOSE 8080

ENTRYPOINT ["/usr/bin/bucketeer"]