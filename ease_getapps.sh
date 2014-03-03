#!/bin/bash

function getJsonVal () { 
    cat | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["'$1'"]'; 
}

if [ $# -lt 1 ] ; then
	echo "Usage: $0 token"
	exit 0
fi

token=$1

curl_response=$(curl -H "Content-Type: application/js" -X POST -d '{"id": 1, "apiVersion": "1.0", "method": "com.apperian.eas.apps.getlist", "params": {"token": "'${token}'"}, "jsonrpc": "2.0"}' https://easesvc.apperian.com/ease.interface.php)

echo $curl_response
