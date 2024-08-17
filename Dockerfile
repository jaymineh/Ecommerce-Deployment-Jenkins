# Use an official nginx image as the base image
FROM nginx:alpine

# Copy the HTML file to the nginx html directory
COPY webapp.html /usr/share/nginx/html/webapp.html

# Copy a custom nginx configuration file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]