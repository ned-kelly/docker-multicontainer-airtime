#!/bin/bash
AIRTIME_INSTALLED="/opt/airtime/airtime_mvc"

if [ ! -e "$AIRTIME_INSTALLED" ]; then
    echo "Prepping airtime for first run..."

    # Run boostrap script..
    /opt/airtime/bootstrap.sh
else
    # We're already installed - just run supervisor..
    /usr/bin/supervisord
fi
