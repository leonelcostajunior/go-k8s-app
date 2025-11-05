# Etapa 1: Builder
FROM golang:1.25.3 AS builder
WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Etapa 2: Runtime
FROM alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates

COPY --from=builder /app/app .

EXPOSE 8080
ENTRYPOINT ["./app"]
