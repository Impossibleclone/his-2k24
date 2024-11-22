#!/usr/bin/env bash

{
    echo "Checking httpd and nginx packages and their services..."

    # Check if httpd and nginx packages are installed
    if rpm -q httpd nginx > /dev/null 2>&1; then
        echo " - One or both web server packages (httpd, nginx) are installed."

        # Check if httpd.socket, httpd.service, and nginx.service are enabled
        if systemctl is-enabled httpd.socket httpd.service nginx.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: One or more web server services are enabled."
        else
            echo " - PASS: No web server services are enabled."
        fi

        # Check if httpd.socket, httpd.service, and nginx.service are active
        if systemctl is-active httpd.socket httpd.service nginx.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: One or more web server services are active."
        else
            echo " - PASS: No web server services are active."
        fi
    else
        echo " - PASS: Neither httpd nor nginx packages are installed."
    fi
}

