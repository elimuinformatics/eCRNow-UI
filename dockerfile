# Stage 1: Build the React application
FROM node:16 AS build
ARG ECR_BASE_URL
WORKDIR /app
COPY package*.json ./
ENV REACT_APP_ECR_BASE_URL = $ECR_BASE_URL
RUN npm install
COPY . ./

# Expose port 80
EXPOSE 3000

# Start Nginx
CMD ["npm","start"]
