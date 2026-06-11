FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/smart-energy-management ./cmd/api

FROM alpine:3.19
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /app
COPY --from=builder /app/smart-energy-management .
COPY --from=builder /app/configs ./configs
EXPOSE 8080
CMD ["./smart-energy-management"]
