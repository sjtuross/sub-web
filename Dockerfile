# ---- Dependencies ----
FROM node:12-alpine AS dependencies
WORKDIR /app
COPY package.json ./
RUN yarn install

# ---- Build ----
FROM dependencies AS build
WORKDIR /app
COPY . /app
RUN yarn build

FROM tindy2013/subconverter:latest

RUN apk add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

RUN mkdir /base/web /overlay

COPY --from=build /app/dist /base/web

EXPOSE 25500

CMD cp -a /overlay/. /base && subconverter
