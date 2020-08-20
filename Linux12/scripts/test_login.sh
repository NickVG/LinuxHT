#!/bin/bash

if [ $(id -Gn ${PAM_USER}|grep -c "admin") != 0 ]; then
  exit 0
fi

if [ $(id -Gn ${PAM_USER}|grep -c "admin") = 0 ]; then
#  if [ $(date +%a) != "Sun" -o $(date +%a) !=  "Sat" -o $(date +%a) != "Wed" ]; then
if [ $(date +%a) != "Sun" -o $(date +%a) != "Sut" ]; then
      exit 0
    else
      exit 1
  fi
fi

#if [ $(id -Gn $PAM_USER|grep -c "admin") != 0 ]; then
#  exit 0
#fi
#
#if [ $(id -Gn $PAM_USER|grep -c "admin") = 0 ]; then
#  if [ $(date +%a) != "Sun" || "Sat" ]; then
#      exit 0
#    else
#      exit 1
#  fi
#fi
