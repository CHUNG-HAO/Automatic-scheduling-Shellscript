FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    bash \
    && rm -rf /var/lib/apt/lists/*

ADD Monitoring.sh /Monitoring.sh

RUN chmod +x /Monitoring.sh

CMD ["/Monitoring.sh"]