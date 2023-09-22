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
RUN apt-get update

# Copy the built React application from the build stage
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]

