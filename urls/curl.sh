#!/usr/bin/env bash

fichier_urls=$1 # le fichier d'URL en entrée
lineno=1

while read -r line;
do
	res=$(curl -sIL $line);
	echo "ligne $lineno:" >> fichier_in_utile.txt;
	echo $res >> fichier_in_utile.txt;
	lineno=$((lineno+1));
done < $fichier_urls
