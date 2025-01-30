FROM semaphoreui/semaphore:latest

ARG WEB_HOST

ENV WEB_HOST=${WEB_HOST}

RUN echo '$WEB_HOST' > /didthiswork

CMD ["/usr/local/bin/server-wrapper"]
