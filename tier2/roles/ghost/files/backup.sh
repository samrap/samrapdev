#!/bin/bash

. /home/samrap/.environment

systools backup -d /home/samrap/ghost_content
systools backup -d /etc/letsencrypt
