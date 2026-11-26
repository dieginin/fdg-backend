FROM node:26-alpine3.24 AS base
WORKDIR /app
RUN npm install --global yarn@1.22.22

FROM base AS dev-deps
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile


FROM base AS builder
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
RUN yarn build


FROM base AS prod-deps
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile


FROM node:26-alpine3.24 AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist


CMD [ "node", "dist/main" ]