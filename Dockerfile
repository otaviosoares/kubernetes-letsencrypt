FROM quay.io/letsencrypt/letsencrypt

MAINTAINER Eli Mallon <eli@iame.li>

ENV KUBE_LATEST_VERSION="v1.4.0"
ENV KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl"

# No curl or wget -- what the hey, let's just download kubernetes with a python one-liner.
RUN cd /usr/bin && \
  python -c "from urllib import urlretrieve; urlretrieve('$KUBE_URL', 'kubectl')" && \
  chmod +x ./kubectl && \
  mkdir /webroot

WORKDIR /app
ADD scripts/get-cert.sh /app/get-cert.sh
ADD scripts/make-webroot-map.py /app/make-webroot-map.py
ADD scripts/entrypoint.sh /app/entrypoint.sh

# Start up the HTTP server at our webroot.
ENTRYPOINT ["/app/entrypoint.sh"]
