FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PIPENV_VENV_IN_PROJECT=1

RUN microdnf update -y && microdnf install python3-pip git gcc python3-devel  -y && pip3 install --no-cache-dir pipenv

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pipenv install --clear"

ADD . /httpbin
RUN pip3 install --no-cache-dir /httpbin

EXPOSE 8080
USER 1000:1000

ENTRYPOINT ["pipenv", "run", "gunicorn", "-b", "0.0.0.0:8080", "httpbin:app", "-k", "gevent"]
