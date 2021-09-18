#!/bin/bash

setup_sudo () {
	sudo apt-get update
  sudo apt-get install -y unzip xvfb libxi6 libgconf-2-4
  sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
  sudo echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get -y update
  sudo apt-get -y install google-chrome-stable
  wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
  unzip chromedriver_linux64.zip
  rm chromedriver_linux64.zip
  sudo mv chromedriver /usr/bin/chromedriver
  sudo chown root:root /usr/bin/chromedriver
  sudo chmod +x /usr/bin/chromedriver
}

setup_no_sudo () {
	apt-get update
  apt-get install -y unzip xvfb libxi6 libgconf-2-4
  curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
  echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
  apt-get -y update
  apt-get -y install google-chrome-stable
  wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
  unzip chromedriver_linux64.zip
  rm chromedriver_linux64.zip
  mv chromedriver /usr/bin/chromedriver
  chown root:root /usr/bin/chromedriver
  chmod +x /usr/bin/chromedriver
}

if [ $USER == 'root' ]
then
  setup_no_sudo
else
  setup_sudo
fi