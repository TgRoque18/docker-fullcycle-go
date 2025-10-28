# Builder stage: build a static Go binary and compress it with upx
FROM golang:1.20 AS builder

WORKDIR /src

# Copy sources
COPY go.mod .
COPY main.go .

# Install upx (Debian based golang image)
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    # download UPX release and extract
    && wget -qO /tmp/upx.tar.xz https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-amd64_linux.tar.xz \
    && tar -xJf /tmp/upx.tar.xz -C /tmp \
    && mv /tmp/upx-4.0.2-amd64_linux/upx /usr/local/bin/upx \
    && chmod +x /usr/local/bin/upx \
    && rm -rf /tmp/upx* /tmp/upx-4.0.2-amd64_linux

# Build static binary and strip symbol table
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o /fullcycle

# Compress binary with upx to reduce image size
RUN upx --best --ultra-brute /fullcycle || true

# Final image: scratch
FROM scratch
COPY --from=builder /fullcycle /fullcycle

ENTRYPOINT ["/fullcycle"]
