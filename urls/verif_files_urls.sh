#!/usr/bin/env bash

#===============================================================================
# fichier_urls -- txt : le fichier contenant les 50 urls, le fichier bash sera
# sera 3 fois pour chacun des fichiers.
# fichier_tableau -- html : le fichier contenant la mise en page du tableau
# 1. on vérifie que les deux fichiers sont bien là et que les arguments marchent
# 2. on vérifie si les urls marchent avec la commande cURL. 
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie

#vérifier si nos deux fichier sont bien là
if [ ! -f $1 ]
then
	echo "fichier urls non trouvé";
	exit
fi

if [ ! -f $2 ]
then
	echo "fichier tableau non trouvé";
	exit
fi


#vérification si TOUTES les urls marchent
echo "Pour $fichier_urls,"

lineno=1;

while read -r line;
do
	header=$(curl -sIL $line);
	grp=$(echo "$header" | egrep "HTTP/(2|1.1) (200|301|302|403)");
	
	echo "url numéro $lineno"; #numéro de la ligne
	echo $grp; #juste partie HTTP

	lineno=$((lineno+1));
done < $fichier_urls
