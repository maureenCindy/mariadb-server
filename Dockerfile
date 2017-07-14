FROM ubuntu:trusty
MAINTAINER Maureen Mpofu<mpofusindie@gmail.com>

# Add MySQL configuration
COPY my.cnf /etc/mysql/conf.d/my.cnf

RUN apt-get update && \
    apt-get -yq install mysql-server

#
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Add MySQL run script
COPY run.sh /run.sh
RUN ["chmod", "+x", "/run.sh"]

ENV MYSQL_USER=developer \
    MYSQL_PASS=developer@@ \


EXPOSE=3306
CMD ["/run.sh"]
