# Use an official Node.js image as a base
# line specifies that you want to use the latest Node.js image as the base for a build stage.
#
FROM node:latest AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files into the container at /app
# This line copies the package.json and package-lock.json files from your local system to the /app directory in the container.
# Using the wildcard package*.json ensures that both package.json and package-lock.json (or package.json and yarn.lock if you're using Yarn) are copied.

# Why just these files first?
# Copying only the package.json and package-lock.json files first allows Docker to cache the dependency installation (npm install) step. 
# This means that if the application code changes but package.json remains the same, Docker can reuse the previous layer, speeding up the build process.
COPY package*.json ./

# Install dependencies
# his installs all the dependencies listed in package.json.
# It's executed inside the /app directory because of the previously set WORKDIR.

#Optimization:
#    Since only the package.json is copied before running this command, the install step is cached. If you later copy the full application and only your code changes, 
 #   Docker will skip reinstalling dependencies, speeding up rebuilds.
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

# Expose port 80 to the outside world
EXPOSE 80

# Start nginx when the container starts
# Why use daemon off;?
# Docker containers expect the main process (the one started by CMD) to stay in the foreground. If the main process exits, 
# the container will stop. Running Nginx in the foreground ensures that the container remains running.
# So, daemon off; is essential for Nginx in a Docker environment to keep the container alive.
# Without this, Nginx would start and immediately exit (since it would detach and run in the background), causing the container to stop.
CMD ["nginx", "-g", "daemon off;"]
