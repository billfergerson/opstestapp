#!/bin/bash

if [ $# -lt 1 ] ; then
        echo "Usage: $0 token"
        exit 0
fi

token=$1

curl_response=$(curl --silent -H "Content-Type: application/js" -X POST -d '{"id": 1, "apiVersion": "1.0", "method": "com.apperian.eas.apps.getlist", "params": {"token": "'${token}'", "name": "OPS_TEST"}, "jsonrpc": "2.0"}' https://easesvc.apperian.com/ease.interface.php)

app_id=$(echo $curl_response | sed -nE "s/.*name\":\"OPS_TEST\",\"ID\":\"(.+)\".*/\1/p" | cut -c1-22)

# echo $curl_response | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed "s/\"//g" | grep "ID:" | sed "s/\"//g"


# Create
#curl -H "Content-Type: application/js" -X POST -d '{"id": 1, "apiVersion": "1.0", "method": "com.apperian.eas.apps.create", "params": {"token": "'${token}'"}, "jsonrpc": "2.0"}' https://easesvc.apperian.com/ease.interface.php
#echo $curl_response | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | grep "ID:" | sed "s/\"//g"


# Update existing 
echo Using App ID $app_id

curl_response=$(curl --silent -H "Content-Type: application/js" -X POST -d '{"id": 1, "apiVersion": "1.0", "method": "com.apperian.eas.apps.update", "params": {"appID": "'${app_id}'", "token": "'${token}'"}, "jsonrpc": "2.0"}' https://easesvc.apperian.com/ease.interface.php)

fileUploadURL=$(echo $curl_response | sed -nE "s/.*\"fileUploadURL\":\"(.+)\",\".*/\1/p" | cut -f1 -d\" | sed "s/\\\//g")

echo File Upload $fileUploadURL

curl_response=$(curl --form "LUuploadFile=@OPS_TEST.ipa" $fileUploadURL)

# Publish
echo $curl_response
transactionID=$(echo $fileUploadURL | cut -f2 -d=)
fileID=$(echo $curl_response | sed -nE "s/.*\"(.+)\"/\1/p" | cut -f1 -d" ")

echo transactionID=$transactionID
echo fileID=$fileID

curl -H "Content-Type: application/js" -X POST -d '{"id": 1, "apiVersion": "1.0", "method": "com.apperian.eas.apps.publish", "params": {"EASEmetadata" :  { "author" : "Example Company", "longdescription" : "Use this app to view the Benefits handbook and complete online enrollment forms.", "name" : "Benefits", "shortdescription" : "Benefits Handbook", "version" : "1.5", "versionNotes" : "Includes 2013 forms"}, "files" :  { "application" : "'${fileID}'"}, "token" : "'${token}'", "transactionID" : "'${transactionID}'"}, "jsonrpc": "2.0"}' https://easesvc.apperian.com/ease.interface.php

