FROM alpine:edge
MAINTAINER Steven Bower <steven@purse.io>

# Cache buster
ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new uuid

# Build deps
RUN apk update && \
    apk upgrade
RUN apk add nodejs bash unrar git python build-base make

ENV BCOIN_BRANCH master
ENV BCOIN_REPO https://github.com/bcoin-org/bcoin.git

RUN mkdir -p /code/node_modules/bcoin /data

RUN git clone --branch $BCOIN_BRANCH $BCOIN_REPO /code/node_modules/bcoin

# Installation
WORKDIR /code/node_modules/bcoin
RUN npm install --production

# Cleanup
RUN npm uninstall node-gyp
RUN apk del unrar python build-base make && \
    rm /var/cache/apk/*

CMD ["node", "/code/node_modules/bcoin/bin/node"]
