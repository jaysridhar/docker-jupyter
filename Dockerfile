FROM ubuntu:16.04
MAINTAINER Jay Sridhar "jay.sridhar@gmail.com"
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx python-pip && \
    pip install --upgrade pip && \
    pip install jupyter && \
    useradd -ms /bin/bash aurora && \
    rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/snippets/fastcgi-php.conf /etc/nginx/snippets/snakeoil.conf
EXPOSE 80
EXPOSE 443
COPY nginx/ssl /etc/nginx/ssl
COPY nginx/snippets /etc/nginx/snippets
COPY nginx/sites-available /etc/nginx/sites-available
COPY .jupyter/jupyter_notebook_config.py /home/aurora/.jupyter/jupyter_notebook_config.py
COPY notebooks /home/aurora/notebooks
COPY etc/startup.sh /etc/startup.sh
RUN chown -R aurora:aurora /home/aurora/.jupyter /home/aurora/notebooks
ENTRYPOINT ["/bin/bash", "-c", "/etc/startup.sh"]
