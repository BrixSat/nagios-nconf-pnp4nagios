FROM debian:bullseye

ENV env prod
ENV  DEBIAN_FRONTEND noninteractive
MAINTAINER <Cesar Araujo>


##
## Create users
##
RUN groupadd nagcmd
RUN useradd nagios
RUN usermod -a -G nagcmd nagios


##
## Apt update
##
RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils debconf-utils sudo


##
## Add sury php
##
RUN apt-get -y install apt-transport-https lsb-release ca-certificates curl
RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get update


##
## Apt install packages
##
RUN apt-get install  -y php7.4-mysql bsd-mailx libmailtools-perl lockfile-progs mime-support bind9-host postfix procmail
#RUN apt-get install -y php7.4-mysql bsd-mailx libmailtools-perl lockfile-progs mime-support bind9-host
RUN apt-get install -y libdbd-mysql-perl nano python3-pip unzip libzip-dev libssl-dev wget vim curl build-essential s3cmd  php7.4 libapache2-mod-php7.4 php7.4-mcrypt supervisor apache2 iputils-ping locate telnetd 


##
## Set mariadb password
##
RUN echo mariadb-server-10.5 mysql-server/root_password password Nag123 | debconf-set-selections \
    && echo mariadb-server-10.5 mysql-server/root_password_again password Nag123 | debconf-set-selections \
    && apt-get install -y mariadb-server-10.5 -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y net-tools --fix-missing


##
## Nagios compilation
##
# RUN curl -L -O  http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.4.9.tar.gz
COPY sources/nagios-4.4.9.tar.gz /tmp/
RUN cd /tmp/&&tar xvf nagios-*.tar.gz
RUN cd /tmp/nagios-*&&./configure --with-nagios-group=nagios --with-command-group=nagcmd
RUN cd /tmp/nagios-*&&make all
RUN cd /tmp/nagios-*&&make install
RUN cd /tmp/nagios-*&&make install-commandmode
RUN cd /tmp/nagios-*&&make install-init
RUN cd /tmp/nagios-*&&make install-config
RUN cd /tmp/nagios-*&&/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
RUN usermod -G nagcmd www-data


##
## Nagios plugins compilation
##
#RUN curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
COPY sources/nagios-plugins-2.3.3.tar.gz /tmp/
RUN cd /tmp/&&tar xvf nagios-plugins-*.tar.gz
RUN cd /tmp/nagios-plugins-*&&./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
RUN cd /tmp/nagios-plugins-*&& make
RUN cd /tmp/nagios-plugins-*&&make install


##
## Install nconf
##
#RUN wget https://github.com/Bonsaif/new-nconf/archive/refs/heads/master.zip -O nconf.zip
COPY sources/new-nconf-master.zip /tmp/nconf.zip
RUN unzip /tmp/nconf.zip -d /var/www/html/
RUN mv /var/www/html/new-nconf-master/ /var/www/html/nconf/
RUN chown -R www-data:www-data /var/www/html/nconf


##
## Install pnp4nagios
##
RUN apt install -y rrdtool php7.4-gd php7.4-xml ssh-client
copy sources/pnp4nagios-master.zip /tmp/pnp4nagios.zip
RUN unzip /tmp/pnp4nagios.zip -d /tmp/
RUN cd /tmp/pnp4nagios-master/&&./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-httpd-conf=/etc/apache2/sites-available/
RUN cd /tmp/pnp4nagios-master/&&make all
RUN cd /tmp/pnp4nagios-master/&&make fullinstall
RUN mv /usr/local/pnp4nagios/share/install.php /usr/local/pnp4nagios/share/install.php_
#RUN /tmp/pnp4nagios-master/scripts/verify_pnp_config_v2.pl  -m bulk -c /usr/local/nagios/etc/nagios.cfg -p /usr/local/pnp4nagios/etc/

##
## Configure apache
##
RUN a2enmod rewrite
RUN a2enmod cgi
RUN a2ensite nagios
RUN a2ensite pnp4nagios
# nagiosadmin:admin
COPY config/htpasswd.users /usr/local/nagios/etc/htpasswd.users


##
## Configure other things
##
RUN chmod a+x  /usr/local/nagios/bin/nagios
RUN cp -dpR /var/www/html/nconf/config.orig/* /var/www/html/nconf/config/
COPY config/deployment.ini /var/www/html/nconf/config/deployment.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nagios.cfg /usr/local/nagios/etc/
COPY scripts/startup.sh /
COPY config/postfix/* /etc/postfix/
RUN mkdir /usr/local/nagios/etc/Default_collector
RUN mkdir /usr/local/nagios/etc/global
RUN chown -R www-data:www-data /usr/local/nagios/etc/Default_collector
RUN chown -R www-data:www-data /usr/local/nagios/etc/global
COPY config/apache /etc/sudoers.d/apache
RUN chmod 0400 /etc/sudoers.d/apache
RUN mkdir /usr/local/nagios/share/images/logos/base
RUN cp -r /usr/local/nagios/share/images/logos/*.gif  /usr/local/nagios/share/images/logos/base/
RUN cp -r /usr/local/nagios/share/images/logos/*.png  /usr/local/nagios/share/images/logos/base/
RUN cp -r /usr/local/nagios/share/images/logos/*.jpg  /usr/local/nagios/share/images/logos/base/


##
## NPRE
##
RUN mkdir /usr/local/nagios/etc/ssl
COPY config/ssl /usr/local/nagios/etc/ssl/


RUN /startup.sh
CMD ["/usr/bin/supervisord"]
EXPOSE 80