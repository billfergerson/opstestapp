#!/bin/bash

# Expects a file with a list of email addresses, one per line, with the filename passed as the argument to this script

echo "First Name,Last Name,User ID,Email,Groups" > new_${1}

while read line ; do
	echo $(echo $line | cut -f1 -d\.)\,$(echo $line|cut -f2 -d\. | cut -f1 -d\@)\,$line,$line,"Mozido Internal" 
done < $1 >> new_${1}

