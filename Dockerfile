# OpenClaw Gateway Docker Image
#
# This Dockerfile creates a deployable image for OpenClaw Gateway service.
# It's designed to work with Zeabur's automatic deployment system.
#
# Usage:
#   docker build -t openclaw-gateway:latest .
#   docker run -e OPENCLAW_GATEWAY_TOKEN=your-token-here openclaw-gateway:latest
#
# Base image: Node.js 18
FROM node:18 AS base

# Set working directory
WORKDIR /app

# Install common dependencies and OpenClaw (as root)
RUN apt-get update && apt-get install -y curl bash

# Install OpenClaw Gateway from install script (must be root)
RUN curl -fsSL https://openclaw.ai/install.sh | bash

# Create openclaw config directory with proper permissions
RUN mkdir -p /home/node/.openclaw && \
    chown -R node:node /home/node/.openclaw

# Switch to node user for security
USER node

# Create config directory structure (populated at runtime via Zeabur volumes)
RUN mkdir -p /home/node/.openclaw/config && chown -R node:node /home/node/.openclaw

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Default environment
ENV NODE_ENV=production
ENV GATEWAY_PORT=8080
ENV GATEWAY_HOST=0.0.0.0

# Expose gateway port
EXPOSE 8080

# Startup command
CMD ["openclaw", "gateway", "--port", "8080"]
