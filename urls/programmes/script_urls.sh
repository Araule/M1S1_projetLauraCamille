#!/usr/bin/env bash

#==============================================================================
# fichier_urls -- txt : le fichier contenant les 50 urls, le fichier bash sera
# sera 3 fois pour chacun des fichiers.
# fichier_tableau -- html : le fichier contenant la mise en page du tableau
# 1. on vérifie que les deux fichiers sont bien là et que les arguments marchent
# 2. on vérifie si les urls marchent avec la commande cURL. 
#===============================================================================

fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie
langue=$3 # chinois, coreen ou français

# on vérifie si nos deux fichiers sont bien là
if [[ $# -ne 3 ]] # si $# est différent de 2
then
	echo "Ce programme demande exactement trois arguments."
	exit # le programme se termine
fi

regexp="看书|读书|阅读|읽[^지|기(를)?]\w+|읽지\s않는(다)?|독서\w+"
# notre expression régulière du verbe  "lire" en chinois, coréen et français
# explication du motif en coréen :
# permet de prendre en compte toutes les terminaisons du verbes
# exclu le radical suivit de 지 car cette terminaisons de la négation est coupé par un espace puis ce poursuit. Exclu le nom 'lecture' qui a la forme 읽기(를)
# prise en compte de la négation dans l'expression suivante.

echo $fichier_urls;

basename=$(basename -s .txt $fichier_urls) # -s : vrai si le fichier txt a bien un nom 
# "basename" command in Linux prints the final component in a file path. 
#             ==> when you want to extract the file name from the long file path.

echo "<html><body>" > $fichier_tableau
echo "<h2>Tableau $basename :</h2>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th><th>aspirations</th><th>occurences</th><th>contextes</th><th>concordances</th></tr>" >> $fichier_tableau

#maintenant on s'occupe des urls
lineno=1;
while read -r URL; do # -r : true if file exists and is readable

	echo -e "\tLigne : $lineno";

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
		#s'il n'existe pas, on lui donne la valeur UTF-8
	else
		echo -e "\tencodage : $charset";
	fi
	

	if [[ $code -eq 200 ]]
	then
		
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		# -dump  : récupère le texte privé de l'url (sans les balises html)
		# -nolist : pour ne pas avoir une liste des urls
		# -assume_charset = on veut récupérer que des pages en utf-8
		# -display_charset = si pas utf-8 alors on remplace

		if [[ $langue == "chinois" ]]
		then
			echo "$dump" > ./fichier.txt
			iconv -f utf-8 -t utf-8 -c ./fichier.txt > ./dumps-text/$basename-$lineno.txt
			dump=$(cat ./dumps-text/$basename-$lineno.txt)
		# il arrive que lynx récupère quelques caractères non utf-8 (rare mais cela arrive)
		# on enlève ces quelques caractères non utf-8 avec la commande iconv et l'option -c
		else
			echo "$dump" > ./dumps-text/$basename-$lineno.txt; # l'ajout de guillemet à résolu le problème du dump/contexte
		fi
		

		curl -Ls $URL > ./aspirations/$basename-$lineno.html;

		
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		# -ne = not equal si $charset est différent de UTF-8 et
		# -n "dump" = le dump n'est pas vide / pas forcément utile car existe forcément car on a utilisé lynx juste avant
		then
			dump=$(echo "$dump" | iconv -f $charset -t UTF-8//IGNORE) #texte dump converti d'encodage d'origine à UTF-8
		fi

		occurences=$(echo "$dump" | grep -Eo $regexp | wc -l)
		echo -e "\toccurences : $occurences";
		
		if [[ ! occurences -ne 0 && $langue == "chinois" ]]
		# dans le cas des urls chinoises, il arrive que certains sites soient encodés en gbk, 
		# et lynx ne prend pas en compte cette encodage, alors on utilise w3m
		then
			dump=$(w3m $URL)
			echo "$dump" > ./dumps-text/$basename-$lineno.txt;
			occurences=$(echo "$dump" | grep -Eo $regexp | wc -l)
			echo -e "\tnouvelles occurences : $occurences";
		fi

	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide";
		dump=""
		charset=""
		#variables vides pour éviter des résultats inattendus
	fi


	egrep -E -B2 -A2 $regexp ./dumps-text/$basename-$lineno.txt > ./contextes/$basename-$lineno.txt
	
	bash programmes/concordance.sh ./dumps-text/$basename-$lineno.txt $regexp $langue> ./concordances/$basename-$lineno.html
	# construction des concordances avec une commande externe

	
	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td><td><a href="./aspirations/$basename-$lineno.txt">$basename-$lineno</a></td><td>$occurences</td><td><a href="./contextes/$basename-$lineno.txt">$basename-$lineno</a></td><td><a href="./concordances/$basename-$lineno.html">$basename-$lineno</a></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	
	lineno=$((lineno+1));

done < $fichier_urls

rm ./fichier.txt
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau
