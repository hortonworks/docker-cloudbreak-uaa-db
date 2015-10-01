FROM postgres:9.4.4

ENV DBNAME uaadb
ENV VERSION 1.0.1

Add ./initial-nouser.sql /docker-entrypoint-initdb.d/
