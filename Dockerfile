FROM armv7/armhf-debian
MAINTAINER Bonhun Koo <darkgs@hanmail.net>

# XXX: Consider switching to nginx.
RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-cli \
        php5-gd \
        php5-curl \
        imagemagick \
        netcat \
        git \
		wget \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && a2enmod rewrite \
    && a2enmod proxy \
    && a2enmod proxy_http \
    # Remove the default Debian index page.
    && rm /var/www/html/index.html

# Waiting in antiticipation for built-time arguments
# https://github.com/docker/docker/issues/14634
#ENV MEDIAWIKI_VERSION wmf/1.27.0-wmf.9

# MediaWiki setup
#RUN set -x; \
#    mkdir -p /usr/src \
#    && git clone \
#        --depth 1 \
#        -b $MEDIAWIKI_VERSION \
#        https://gerrit.wikimedia.org/r/p/mediawiki/core.git \
#        /usr/src/mediawiki \
#    && cd /usr/src/mediawiki \
#    && git submodule update --init skins \
#    && git submodule update --init vendor \
#    && cd extensions \
    # VisualEditor
    # TODO: make submodules shallow clones?
#    && git submodule update --init VisualEditor \
#    && cd VisualEditor \
#    && git checkout $MEDIAWIKI_VERSION \
#    && git submodule update --init

# MediaWiki setup
RUN set -x; \
    mkdir -p /usr/src \
	&& cd /usr/src \
	&& wget https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.2.tar.gz \
	&& tar xvzf mediawiki-1.28.2.tar.gz \
	&& mv mediawiki-1.28.2 mediawiki

COPY php.ini /usr/local/etc/php/conf.d/mediawiki.ini

COPY apache/mediawiki.conf /etc/apache2/
RUN echo "Include /etc/apache2/mediawiki.conf" >> /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
