# Step 1: Build the Go binary
FROM golang:alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Build the binary specifically from the cmd/api folder
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./cmd/api

# Step 2: Create the lightweight final image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
# Fiber runs on 3000 by default
EXPOSE 3000 
CMD ["./main"]