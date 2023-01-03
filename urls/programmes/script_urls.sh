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
langue=$3 # chinois, coreen ou français

# on vérifie si nos deux fichiers sont bien là
if [[ $# -ne 3 ]] # si $# est différent de 2
then
	echo "Ce programme demande exactement trois arguments."
	exit # le programme se termine
fi

regexp="看书|读书|阅读|看\b书|읽지(도|않(는|았어도)?|못하는)|읽었(으니|을(뿐이다)?|다(고)?|던|는(지|데)?|느냐|어요)|읽는(다(면|고|는)?|데(서)?|지를|것보다)|읽어(야(만|합니다|할|겠다)?|주(기(도|가)?)|면|며|보(시)?는|(세)?요|니|볼|봐야겠다는|나가야겠다고|봤자|달라고|내지|들립니다|준다|라|서|나갈|요)|읽을(수(있는|록)?|거라는|지|까)|읽으(면(서(도)?)?|라고|려는|니까|시(나요|는)?|세요|십시요)|읽고(자하는|서는|나면|난)?|읽(던|습니다|다(가|보면)?|나|더라도|죠|도록|기도|게|든|힐|힌다|힙니다|히지)|읽은(것)?|읽자(는)?|읽혀(서|진)?|독서(하(지|다|는)?|할|한|했다)?"
# notre expression régulière du verbe  "lire" en chinois, corréen et français

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
		echo "$dump" > ./dumps-text/$basename-$lineno.txt; # l'ajout de guillemet à résolu le problème du dump/contexte
		curl -Ls $URL > ./aspirations/$basename-$lineno.html;
		# -dump  : récupère le texte privé de l'url (sans les balises html)
		# -nolist : pour ne pas avoir une liste des urls
		# -assume_charset = on veut récupérer que des pages en utf-8
		# -display_charset = si pas utf-8 alors on remplace
		
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		# -ne = not equal si $charset est différent de UTF-8 et
		# -n "dump" = le dump n'est pas vide / pas forcément utile car existe forcément car on a utilisé lynx juste avant
		then
			dump=$(echo "$dump" | iconv -f $charset -t UTF-8//IGNORE) #texte dump converti d'encodage d'origine à UTF-8
		fi

		occurences=$(echo "$dump" | grep -Eo $regexp | wc -l)
		echo -e "\toccurences : $occurences";
		
		if [[ ! occurences -ne 0 ]]
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
		
	bash programmes/concordance.sh ./dumps-text/$basename-$lineno.txt $regexp $langue > ./concordances/$basename-$lineno.html
	# construction des concordances avec une commande externe

	
	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td><td><a href="./aspirations/$basename-$lineno.txt">$basename-$lineno</a></td><td>$occurences</td><td><a href="./contextes/$basename-$lineno.txt">$basename-$lineno</a></td><td><a href="./concordances/$basename-$lineno.html">$basename-$lineno</a></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	
	lineno=$((lineno+1));

done < $fichier_urls
echo "</table>" >> $fichier_tableau
echo "</body></html>" >> $fichier_tableau
