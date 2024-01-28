#!/bin/bash

sudo apt-get -yqq update
sudo apt-get -yqq install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get -yqq install ansible
