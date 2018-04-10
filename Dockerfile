FROM lsiobase/alpine.python:3.7

# set python to use utf-8 rather than ascii.
ENV PYTHONIOENCODING="UTF-8"

RUN apk add --update git py-pip jpeg-dev && \
    git clone -b master --single-branch https://github.com/morpheus65535/oscarr.git /oscarr && \
    pip install -r /oscarr/requirements.txt

VOLUME /oscarr/data

EXPOSE 5656

CMD ["python", "/oscarr/oscarr.py"]
