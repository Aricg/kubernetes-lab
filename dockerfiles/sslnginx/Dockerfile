FROM nginx
RUN apt-get update && \
    apt-get install -y openssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt -subj "/CN=localhost"

# Create the welcome HTML file
RUN echo '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Welcome</title></head><body><h1>Welcome over nested HTTPS!</h1></body></html>' > /usr/share/nginx/html/welcome.html

# Update the nginx configuration to serve the welcome HTML file
RUN echo 'server { listen 443 ssl; ssl_certificate /etc/nginx/cert.crt; ssl_certificate_key /etc/nginx/cert.key; location / { root /usr/share/nginx/html; index welcome.html; } }' > /etc/nginx/conf.d/default.conf

