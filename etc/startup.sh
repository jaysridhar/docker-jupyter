#!/bin/bash

su -l -c 'jupyter notebook &' aurora
/usr/sbin/nginx -g 'daemon off;'
