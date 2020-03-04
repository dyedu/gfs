#!/bin/bash
##############################
#####Setting Environments#####
echo "Setting Environments"
set -e
export PATH=$PATH:$GOPATH/bin:$HOME/bin:$GOROOT/bin
##############################
######Install Dependence######
echo "Installing Dependence"
if [ "$1" = "-u" ];then
 twd=`pwd`
 echo "Running Clear"
 cd  $GOPATH/src/github.com/Centny/gfs/
 git pull
 cd $twd
fi
##############################
#########Running Clear#########
#########Running Test#########
echo "Running Test"
pkgs="\
 github.com/Centny/gfs/gfsapi\
"
pkgs="\
 github.com/Centny/gfs/gfsdb\
 github.com/Centny/gfs/gfsapi\
 github.com/Centny/gfs\
 github.com/Centny/gfs/gfs\
"
echo "mode: set" > a.out
for p in $pkgs;
do
 go test -v --coverprofile=c.out $p
 cat c.out | grep -v "mode" >>a.out
 go install $p
done
gocov convert a.out > coverage.json

##############################
#####Create Coverage Report###
echo "Create Coverage Report"
cat coverage.json | gocov-xml -b $GOPATH/src > coverage.xml
cat coverage.json | gocov-html coverage.json > coverage.html

######
# go install github.com/Centny/ffcm/ffcm
