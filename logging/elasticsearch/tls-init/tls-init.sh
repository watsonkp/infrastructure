#!/bin/bash
set -xe

elasticsearch-certutil cert --ca /secret/elastic-stack-ca.p12 --ca-pass $CA_KEYSTORE_PASSWORD --pass $TRANSPORT_KEYSTORE_PASSWORD --name es0 --out /key/elastic-certificates.p12
chmod 644 /key/elastic-certificates.p12

elasticsearch-certutil cert --ca /secret/elastic-stack-ca.p12 --ca-pass $CA_KEYSTORE_PASSWORD --days 365 --name es0 --pass $HTTP_KEYSTORE_PASSWORD --dns $HTTP_DNS --out /key/http.p12
chmod 644 /key/http.p12
