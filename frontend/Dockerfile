FROM node:18 AS front-build
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM nginx:alpine
COPY webserver/nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*
COPY --from=front-build /app/dist /usr/share/nginx/html
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
