#!/bin/bash

php /help/config.php

source /etc/apache2/envvars
exec apache2 -D FOREGROUND