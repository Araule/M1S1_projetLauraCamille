#!/usr/bin/env bash

#===============================================================================
# fichier_urls -- txt : le fichier contenant les 50 urls, le fichier bash sera
# sera 3 fois pour chacun des fichiers.
# fichier_tableau -- html : le fichier contenant la mise en page du tableau
# 1. on vérifie que les deux fichiers sont bien là et que les arguments marchent
# 2. on vérifie si les urls marchent avec la commande cURL. 
# fichier_in_utile.txt contient les informations des urls avec un problème, il
# n'est pas très important, on peut le supprimer après utilisation
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
#fichier_tableau=$2 # le fichier HTML en sortie

#vérifier si nos deux fichier sont bien là
if [ ! -f $1 ]
then
	echo "fichier urls non trouvé";
	exit
fi

#if [ ! -f $2 ]
#then
	#echo "fichier tableau non trouvé";
	#exit
#fi


#vérification si TOUTES les urls marchent
lineno=1

echo "pour $fichier_urls, il faut vérifier qu'il n'y ait pas de problèmes avec les urls suivantes :" >> fichier_in_utile.txt;

while read -r line;
do
	crl=$(curl -sIL $line > fichier_curl.txt);
	grp=$(grep "HTTP/(2|1.1) (200|301|302)" $crl);

	if [ ! $grp -s  ] #si urls n'ont pas dans l'entête HTTP** 200, 301, ou 302
	then
		echo "url numéro $lineno" >> fichier_in_utile.txt; #numéro de la ligne
		echo $crl >> fichier_in_utile.txt; #entête en entier
		exit
	fi

	lineno=$((lineno+1));
done < $fichier_urls