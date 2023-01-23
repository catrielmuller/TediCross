# Setup Builder Image
FROM node:16-alpine AS builder

# Install build dependencies
RUN apk add --no-cache --virtual .gyp python3 make g++ sqlite-libs

# Copy Source Files
WORKDIR /build
COPY . ./

# Install Node Deps
RUN yarn install

# Setup Runner
FROM node:16-alpine AS app
WORKDIR /opt/TediCross

COPY --from=builder /build/node_modules ./node_modules
COPY --from=builder /build/dist ./dist
COPY --from=builder /build/package.json ./package.json

# The node user (from node:16-alpine) has UID 1000, meaning most people with single-user systems will not have to change UID
USER node

VOLUME /opt/TediCross/data/
ENTRYPOINT /usr/local/bin/yarn start -c data/settings.yaml
