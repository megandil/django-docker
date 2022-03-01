FROM debian
RUN apt-get update && apt-get install -y python3-pip python3-dev default-libmysqlclient-dev build-essential  && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY build/django_tutorial /usr/share/app
WORKDIR /usr/share/app
RUN pip3 install --no-cache-dir -r requirements.txt
ENV DJANGO_BD=django
ENV DJANGO_BD_USER=django
ENV DJANGO_BD_PASSWORD=django
ENV DJANGO_BD_HOST=mariadb
ENV SUPERUSER_NAME=admin
ENV SUPERUSER_PASS=admin
COPY build/docker-entrypoint.sh /usr/share/app
EXPOSE 8000
CMD [ "bash", "/usr/share/app/docker-entrypoint.sh"]