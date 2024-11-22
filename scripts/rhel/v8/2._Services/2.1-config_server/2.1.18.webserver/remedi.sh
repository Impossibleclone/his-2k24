#!/usr/bin/env bash

{
    echo "Remediating httpd and nginx packages and services..."

    # Check if httpd and nginx packages are installed
    if rpm -q httpd nginx > /dev/null 2>&1; then
        echo " - One or both web server packages (httpd, nginx) are installed."

        # Stop httpd.socket, httpd.service, and nginx.service
        systemctl stop httpd.socket httpd.service nginx.service

        # Check if httpd or nginx have dependencies
        if rpm -q --whatrequires httpd nginx > /dev/null 2>&1; then
            echo " - Web server packages are required by other packages. Masking services."
            systemctl mask httpd.socket httpd.service nginx.service
        else
            echo " - No dependencies found. Removing httpd and nginx packages."
            dnf remove -y httpd nginx
        fi
    else
        echo " - Neither httpd nor nginx packages are installed. No action needed."
    fi
}

