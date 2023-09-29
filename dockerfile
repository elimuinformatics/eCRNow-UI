# Stage 1: Build the Node.js application
FROM node:16 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . ./

# Set environment variables as build arguments
ARG REACT_APP_ECR_BASE_URL
ENV REACT_APP_ECR_BASE_URL=$REACT_APP_ECR_BASE_URL

RUN npm run build

# Stage 2: Serve the application using NGINX
FROM nginx:stable
RUN apt-get update && apt-get install -y \
    apache2-utils \
    moreutils \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy the built React application from the build stage
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /etc/nginx
COPY docker-entrypoint.sh /etc/nginx
RUN chmod 755 /etc/nginx/docker-entrypoint.sh
EXPOSE 80

ENTRYPOINT ["/etc/nginx/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

