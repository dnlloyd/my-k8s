FROM python:3.10-alpine AS builder

WORKDIR /code
COPY flask_auth_app /code

RUN mkdir /data
VOLUME /data

# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install -r requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

# ENV NEW_RELIC_LOG=stdout \
#     NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true \
#     NEW_RELIC_APP_NAME="flask-auth" \
#     NEW_RELIC_LICENSE_KEY=YOUR_LICENSE_KEY

ENV FLASK_APP project
ENV FLASK_ENV development
ENV FLASK_RUN_PORT 80
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_DEBUG 1

EXPOSE 80

ENV NEW_RELIC_CONFIG_FILE=/etc/newrelic/newrelic.ini

ENTRYPOINT ["newrelic-admin", "run-program"]

CMD ["flask", "run"]
