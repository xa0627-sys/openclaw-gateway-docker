# OpenClaw Gateway Docker Image
# 
# This Dockerfile creates a deployable image for OpenClaw Gateway service.
# It's designed to work with Zeabur's automatic deployment system.
#
# Usage:
#   docker build -t openclaw-gateway:latest .
#   docker run -e OPENCLAW_GATEWAY_TOKEN=your-token-here openclaw-gateway:latest
#
# Base image: Use the OpenClaw gateway image
# Replace with your actual base image source
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Install OpenClaw CLI or copy your gateway binary
# Example 1: If using npm package
# RUN npm install -g @openclaw/gateway
#
# Example 2: If copying from local build
# COPY --from=builder /app/dist ./dist
#
# Example 3: If pulling from registry
# For now, we'll create a placeholder that works with Zeabur

# Install common dependencies
RUN apk add --no-cache curl bash

# Create openclaw config directory with proper permissions
RUN mkdir -p /home/node/.openclaw && \
    chown -R node:node /home/node/.openclaw

# Switch to node user for security
USER node

# Copy any local config (optional - will be overridden by mounted volumes)
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
# Adjust this based on your actual OpenClaw CLI command
# Common patterns:
# - openclaw gateway --config /home/node/.openclaw/openclaw.json
# - openclaw-gateway start
# - node /app/dist/gateway/server.js
#
# For Zeabur deployment, we'll use a flexible startup

# Install OpenClaw Gateway from npm
RUN npm install -g openclaw

CMD ["openclaw", "gateway", "--port", "8080"]
