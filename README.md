
# Nginx proxy container

Set up your virtual hosts in one command!

### Configuration

**Your .env file:**

    APP_PORT=80
    APP_HTTPS_PORT=443
    CERTBOT=no-skip

Set any different value to CERTBOT to prevent Certbot from being installed

<hr>

**Your proxy.yml file:**

    active: site1, site2
    
    site1:
      domain: site1.com
      port: 8001
      proxy: localhost
      
    site2:
      domain: site2.com
      port: 8001
      proxy: localhost
      

**domain** - server name for Nginx

**port** - proxy port

**proxy** - where the requests are redirected
** 

### Setting up

- clone this repository
- configure your `.env` and `proxy.yml` files
- docker-compose up

### Setting up certbot

- log into container via `docker-compose exec nginx bash`
- run `certbot && certbot renew --dry-run`