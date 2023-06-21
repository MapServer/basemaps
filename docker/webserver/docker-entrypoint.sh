#!/bin/bash

make -f docker.mk -C /etc/mapserver all data

exec "$@"
