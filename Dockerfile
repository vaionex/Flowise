# Build local monorepo image
# docker build --no-cache -t  flowise .

# Run image
# docker run -d -p 3000:3000 flowise

FROM --platform=linux/amd64 node:18-alpine
RUN apk add --no-cache python3 make g++
RUN apk add --update libc6-compat
# needed for pdfjs-dist
RUN apk add --no-cache build-base cairo-dev pango-dev
ENV PUPPETEER_SKIP_DOWNLOAD=true

WORKDIR /usr/src/packages

# Copy root package.json and lockfile
COPY package.json yarn.loc[k] ./

# Copy components package.json
COPY packages/components/package.json ./packages/components/package.json

# Copy ui package.json
COPY packages/ui/package.json ./packages/ui/package.json

# Copy server package.json
COPY packages/server/package.json ./packages/server/package.json

RUN yarn install

# Copy app source
COPY . .

RUN yarn build

EXPOSE 3000

CMD [ "yarn", "start" ]
