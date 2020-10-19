# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lmireya <lmireya@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/10/19 18:38:02 by lmireya           #+#    #+#              #
#    Updated: 2020/10/19 21:53:13 by lmireya          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = ft_server
VERSION = latest

.PHONY: build
build:
	docker build -t $(NAME):$(VERSION) .

.PHONY: run
run:
	docker run -p 80:80 -p 443:443 --name $(NAME) -d $(NAME):$(VERSION)

.PHONY : rm
rm:
	docker stop $(NAME)
	docker rm $(NAME)
	docker rmi $(NAME):$(VERSION)

.PHONY: exec
exec:
	docker exec -it $(NAME) /bin/bash