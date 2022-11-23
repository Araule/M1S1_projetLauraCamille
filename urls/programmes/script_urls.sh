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
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th><th>occurences</th></tr>" >> $fichier_tableau

#maintenant on s'occupe des urls
lineno=1;
while read -r URL; #-r : true if file exists and is readable.

do
	echo -e "\tURL : $URL"; #on découpe chacun des appels / on récupère d'abord le code
	# la façon attendue, sans l'option -w de cURL
	code=$(curl -ILs $URL | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | tail -n 1) # on récupère code HTTP
	# egrep = grep -e ; recherche la ligne qui commence par "^HTTP/" et qui contient le code de retour
	#grep -Eo = grep étendu (-E) et on récupère uniquement la ligne voulue (-o)
	#si tail -n 1 : on prend  que la dernière ligne de l'url quand elle est redirigée.
	
	charset=$(curl -ILs $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2 | tail -n 1) # on récupère encodage
	#(\w|-)+ = on recherche des lettres ou des chiffres ou des tirets. On veut une séquence
	# cut -d= -f2 : on veut la deuxième colonne
	#-f = on veut récupérer un colonne (le chiffre qui suit = colonne qu'on souhaite)
	#-d = délimiteur, le signe qui est après -d désigne le délimiteur

	# autre façon, avec l'option -w de cURL
	# code=$(curl -Ls -o /dev/null -w "%{http_code}" $URL)
	# charset=$(curl -ILs -o /dev/null -w "%{content_type}" $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2)

	echo -e "\tcode : $code";

	if [[ ! $charset ]]
	then
		echo -e "\tencodage non détecté, on prendra UTF-8 par défaut.";
		charset="UTF-8";
		# = chaine vide
	else
		echo -e "\tencodage : $charset";
		# s'il n'existe pas, on lui donne la valeur UTF-8
	fi

	if [[ $code -eq 200 ]]	
	then
		html=$(curl -sL $URL)
		echo $html > ./aspirations/$basename-$lineno.html;
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		# -dump  : récupère le texte privé de l'url (sans les balises html)
		# -nolist : pour ne pas avoir une liste des urls
		# -assume_charset = on veut récupérer que des pages en utf-8
		# -display_charset=si pas utf-8 alors on remplace
		
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		# -ne = not equal si $charset est différent de UTF-8 et
		# -n "dump" = le dump n'est pas vide / pas forcément utile car existe forcément car on a utilisé lynx juste avant
		then
			dump=$(echo $dump | iconv -f $charset -t UTF-8//IGNORE) #texte dump converti d'encodage d'origine xx à UTF-8
		fi

		echo $dump > ./dumps-text/$basename-$lineno.txt
		occurences=$( echo $dump | grep -Eo "看书|阅读|读书 |.. " | wc -l)
		# mettre toutes les formes conjuguées des verbes.
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide"
		dump=""
		charset=""
		#variables vides pour éviter des résultats inattendus
	fi

	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td><td>$occurences</td></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	lineno=$((lineno+1));
done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau


# stocker les pages aspirées par cURL dans le dossier aspirations ;
# stocker les dumps textuels récupérés avec Lynx dans le dossier dumps-text.
