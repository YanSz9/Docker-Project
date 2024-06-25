FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 \
    php libapache2-mod-php \
    git \
    graphviz aspell ghostscript clamav php-pspell php-curl php-gd php-intl \
    php-mysql php-xml php-xmlrpc php-ldap php-zip php-soap php-mbstring && \
    rm -rf /var/lib/apt/lists/*

RUN git clone -b MOODLE_403_STABLE --depth 1 https://github.com/moodle/moodle.git /var/www/html/moodle


RUN mkdir /var/www/html/moodledata

RUN chown -R www-data:www-data /var/www/html/moodle /var/www/html/moodledata && \
    chmod -R 755 /var/www/html/moodle /var/www/html/moodledata

RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i 's!/var/www/html!/var/www/html/moodle!g' /etc/apache2/sites-available/000-default.conf && \
    service apache2 restart


EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
