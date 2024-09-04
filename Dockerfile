# Use an official Node.js image as a base
FROM node:latest AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files into the container at /app
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container at /app
COPY . .

# Build the Angular app for production
RUN npm install -g @angular/cli
RUN ng build 

# Use a lightweight web server to serve the Angular app
FROM nginx:alpine

# Copy the built Angular app from the build stage into the nginx web server's html directory
COPY --from=build /app/dist/portfolio/* /usr/share/nginx/html/
COPY nginx.conf /etc/nginx

# Expose port 80 to the outside world
EXPOSE 80

# Start nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
