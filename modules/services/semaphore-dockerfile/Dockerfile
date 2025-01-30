FROM semaphoreui/semaphore:latest

USER root

ARG WEB_HOST

RUN echo "${WEB_HOST}" > /didthiswork

USER semaphore
