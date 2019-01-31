#!/bin/env bash

DIRSRC='/usr/local/src'
ALS=('al.sysadmin-env' 'al.vim-env' 'al.docker')

cd "${DIRSRC}"

yum -y update
yum -y install git
git clone https://github.com/DeaDSouL/AutoLinux.git


for al in ${ALS[@]}; do
    bash "${DIRSRC}/AutoLinux/CentOS/${al}" install
done

