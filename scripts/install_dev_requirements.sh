#!/bin/bash
# Install development requirements to check this project on Raspbian Buster
# Note: run this script with sudo
apt update
apt install python3-bashate shellcheck yamllint
