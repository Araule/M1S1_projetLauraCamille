#!/usr/bin/env bash

#===============================================================================
# VOUS DEVEZ MODIFIER CE BLOC DE COMMENTAIRES.
# Ici, on décrit le comportement du programme.
# Indiquez, entre autres, comment on lance le programme et quels sont
# les paramètres.
# La forme est indicative, sentez-vous libres d'en changer !
# Notamment pour quelque chose de plus léger, il n'y a pas de norme en bash.
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie

if [[ $# -ne 2 ]] 
then
	echo "Ce programme demande exactement deux arguments."
	exit
fi

mot="robot" # à modifier

echo $fichier_urls;
basename=$(basename -s .txt $fichier_urls)

echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th></tr>" >> $fichier_tableau

lineno=1;
while read -r URL; do
	echo -e "\tURL : $URL";
	# la façon attendue, sans l'option -w de cURL
	code=$(curl -ILs $URL | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | tail -n 1) 
	#on découpe chacun des appels/ on récupère d'abord le code
	# egrep = grep -e
	# On recherche la ligne qui commence par "^HTTP/" et qui contient le code de retour
	#grep -Eo = grep étendu (-E) et on récupère uniquement la ligne voulue (-o)
	#on aurait pu faire : à la place de grep -Eo : cut -d " " -f2 pour dire qu'on récupérait l'info de la deuxième colonne (càd le code) 
	#si tail -n1 : on prend  que la dernière ligne de l'url quand elle est redirigée.
	
	charset=$(curl -ILs $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2| tail -n1) 
	# puis on récupère l'encodage
	# grep -Eo "charset=(\w|-)+"
	#(\w|-) = on recherche des lettres ou des chiffres ou des tirets. On en veut une séquence
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
		# = chaîne vide
	else
		echo -e "\tencodage : $charset";
		# s'il existe pas, on lui donne la valeur UTF-8
	fi

	if [[ $code -eq 200 ]] #si notre code est égale à 200
	then
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		# -dump  : récupère le texte privé de l'url (balise html)
		#-no list : pour ne pas avoir une liste des urls
		# -assume_charset = on veut récupérer que des pages en utf-8
		#-display_charset=si pas utf-8 alors on remplace
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		# -ne = not equal
		# -n "dump" = le dump n'est pas vide / pas forcément utile car existe forcément car on a utilisé lynx juste avant
		then
			dump=$(echo $dump | iconv -f $charset -t UTF-8//IGNORE)
			# iconv permet de remplacer l'encodage d'origine par UTF-8
		fi
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide"
		dump=""
		charset=""
		#variables vides pour éviter des résultats inattendus
	fi

	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	lineno=$((lineno+1));
done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau
