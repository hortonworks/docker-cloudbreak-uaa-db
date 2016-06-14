FROM postgres:9.4.4

ENV REPONAME cloudbreak-uaadb
ENV DBNAME uaadb
ENV VERSION 2.7.1

ENV BACKUP_TGZ /initdb/$DBNAME-$VERSION.tgz

ADD https://github.com/hortonworks/docker-${REPONAME}/releases/download/${VERSION}/${DBNAME}-${VERSION}.tgz $BACKUP_TGZ
ADD /start /

ENTRYPOINT [ "/start" ]
CMD ["postgres"]
