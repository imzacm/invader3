FROM node:16-alpine AS builder
WORKDIR /usr/src/app
RUN apk add curl
RUN curl -L https://unpkg.com/@pnpm/self-installer | node && \
    pnpm config set store-dir /usr/src/app/.pnpm-store
COPY *.json *.yaml *.js .*rc ./
RUN pnpm install
COPY src ./src
RUN pnpm run build

FROM nginx:stable-alpine
ENV PORT=8080
EXPOSE $PORT
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
# Overriding the nginx command to evaluate env pariables in the config at runtime
CMD sh -c "envsubst \"`env | awk -F = '{printf \" \\\\$%s\", $1}'`\" < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
