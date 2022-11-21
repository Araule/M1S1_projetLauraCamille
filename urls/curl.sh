#!/usr/bin/env bash

# ce fichier permet d'afficher dans curl.txt 
# tous les headers des 50 urls

fichier_urls=$1 # le fichier d'URL en entrée

echo "Pour $fichier_urls," >> curl.txt

lineno=1;

while read -r line;
do
	echo "url numéro $lineno" >> curl.txt; #numéro de la ligne
	curl -sIL $line >> curl.txt

	lineno=$((lineno+1));
done < $fichier_urls