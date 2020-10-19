# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lmireya <lmireya@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/19 18:37:49 by lmireya           #+#    #+#              #
#    Updated: 2020/10/19 22:22:52 by lmireya          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y vim wget php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp \
php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml \
php7.3-cli php7.3-zip php7.3-soap php7.3-imap nginx mariadb-server openssl \
&& rm -rf /etc/nginx/sites-available/default \
&& rm -rf /etc/nginx/sites-enabled/default \
&& mkdir -p /var/www/html

# config access
RUN chown -R www-data /var/www/* && chmod -R 755 /var/www/*

# ssl sertificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out \
/etc/nginx/ssl/lmireya.pem -keyout /etc/nginx/ssl/lmireya.key -subj \
"/C=RU/ST=Moscow/L=Moscow/O=21 School/OU=lmireya/CN=lmireya"

# nginx configure
COPY srcs/lmireya /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/lmireya /etc/nginx/sites-enabled/lmireya

# database creation
COPY srcs/db.sh /var/
RUN bash /var/db.sh

# phpmyadmin
ADD srcs/phpMyAdmin.tar.gz /var/www/html
RUN mv /var/www/html/phpMyAdmin-4.9.5-all-languages /var/www/html/phpmyadmin
COPY srcs/config.inc.php /var/www/html/phpmyadmin

# wordpress
ADD srcs/wordpress-5.4.2.tar.gz /var/www/html
COPY srcs/wp-config.php /var/www/html/wordpress
RUN rm -rf /var/www/html/phpmyadmin/config.sample.inc.php

EXPOSE 80 443

# server starter
COPY srcs/run_server.sh /var/
COPY srcs/autoindex.sh /var/
CMD bash /var/run_server.sh