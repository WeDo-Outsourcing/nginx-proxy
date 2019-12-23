FROM nginx:1.13

ARG CERTBOT
ADD ./docker /var/www/docker
ADD ./proxy.yml /var/www/docker/proxy.yml

RUN bash /var/www/docker/vhosts.sh $CERTBOT

