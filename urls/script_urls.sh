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

#vérifier si nos deux fichiers sont bien là
if [[ $# -ne 2 ]] # -ne : si $# est différent de 2
then
	echo "Ce programme demande exactement deux arguments."
	exit # le programme se termine
fi

mot="Lire" # à modifier en fonction de la langue

echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls) # - s : vrai si le fichier txt a bien un nom 
# "basename" command in Linux prints the final component in a file path. 
# => when you want to extract the file name from the long file path.

echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th></tr>" >> $fichier_tableau



#maintenant on s'occupe des urls
lineno=1;

while read -r line;
do
	header=$(curl -sIL $line);
	grp=$(echo "$header" | egrep "HTTP/(2|1.1) (200|301|302|403)");
	
	echo "url numéro $lineno"; #numéro de la ligne
	echo $grp; #juste partie HTTP

	lineno=$((lineno+1));
done < $fichier_urls

lineno=1;
while read -r URL; 
do
	echo -e "\tURL : $URL";
	# la façon attendue, sans l'option -w de cURL
	code=$(curl -ILs $URL | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | tail -n 1)
	charset=$(curl -ILs $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	# autre façon, avec l'option -w de cURL
	# code=$(curl -Ls -o /dev/null -w "%{http_code}" $URL)
	# charset=$(curl -ILs -o /dev/null -w "%{content_type}" $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	echo -e "\tcode : $code";

	if [[ ! $charset ]]
	then
		echo -e "\tencodage non détecté, on prendra UTF-8 par défaut.";
		charset="UTF-8";
	else
		echo -e "\tencodage : $charset";
	fi

	if [[ $code -eq 200 ]]
	then
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		then
			dump=$(echo $dump | iconv -f $charset -t UTF-8//IGNORE)
		fi
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide"
		dump=""
		charset=""
	fi

	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	lineno=$((lineno+1));
done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau