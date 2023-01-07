#!/usr/bin/env bash

#==============================================================================
# fichier_urls -- txt : le fichier contenant les 50 urls
# fichier_tableau -- html : le fichier contenant la mise en page du tableau
# langue -- str : variable qui permet d'utiliser le fichier pour les 3 langues
#==============================================================================


fichier_urls=$1 # le fichier d'URL en entrée
fichier_tableau=$2 # le fichier HTML en sortie
langue=$3 # la langue avec laquelle le fichier va travailler, ici : chinois, coreen ou francais


#=== on vérifie si les trois arguments sont bien là
if [[ $# -ne 3 ]] 
then
	echo "Ce programme demande exactement trois arguments."
	exit # le programme se termine
fi


#=== setup de l'expression régulière
if [[ $langue == "chinois" ]]
then
    regexp="看书|读书|阅读"
elif [[ $langue == "coreen" ]]
then
   regexp="읽[^지|기]\w+|읽지\s않는\w+|독서\w+"
else
   regexp="lir\w+|lis\w+?|lis"
fi


echo $fichier_urls;


#=== basename command permet d'extraire le nom du fichier
basename=$(basename -s .txt $fichier_urls) # -s : vrai si le fichier txt a bien un nom 


#=== print dans le fichier tableau le début du code html
echo "<section class='section mx-6 mt-5 mb-6'>" > $fichier_tableau
echo "<div class='block has-text-centered'>" >> $fichier_tableau
echo "<p class='title is-2 has-is-centered'>Tableau $basename</p>	" >> $fichier_tableau
echo "</div>" >> $fichier_tableau
echo "<br/>" >> $fichier_tableau
echo "<table class='table is-bordered is-striped is-fullwidth'>" >> $fichier_tableau
echo "<thead>" >> $fichier_tableau
echo "<tr><th>ligne</th><th>code</th><th>URL</th><th>encodage</th><th>aspirations</th><th>occurences</th><th>contextes</th><th>concordances</th></tr>" >> $fichier_tableau
echo "</thead>" >> $fichier_tableau


#=== le compteur de ligne de la boucle while
lineno=1;


#=== on travaille maintenant avec les url
while read -r URL; do # -r : true if file exists and is readable

	echo -e "\tLigne : $lineno"; # print le numéro de ligne dans le terminal 
	echo -e "\tURL : $URL"; # print l'url dans le terminal


	#=== on récupère le code HTTP de l'url
	code=$(curl -ILs $URL | grep -e "^HTTP/" | grep -Eo "[0-9]{3}" | tail -n 1)
	# grep -e : recherche la ligne qui commence par "^HTTP/" et qui contient le code de retour
	# grep -E -o = - grep étendu - récupère uniquement la ligne voulue
	# tail -n 1 : prend  seulement le dernier code


	#=== on récupère l'encode de l'url
	charset=$(curl -ILs $URL | grep -Eo "charset=(\w|-)+" | cut -d= -f2 | tail -n 1)
	# (\w|-)+ = on recherche des lettres ou des chiffres ou des tirets. On veut une séquence
	# cut -d= -f2 : - permet de délimiter, le signe qui est après -d désigne le délimiteur - récupère la colonne 2


	echo -e "\tcode : $code"; # print le code HTTP dans le terminal


	#=== si on ne récupère pas l'encode de l'url, on assigne par défaut l'encode UTF-8
	if [[ ! $charset ]]
	then
		echo -e "\tencodage non détecté, on prendra UTF-8 par défaut."; # on print l'encodage dans le terminal
		charset="UTF-8";
	else
		echo -e "\tencodage : $charset"; # on print l'encodage dans le terminal
	fi

	
	#=== si le code HTTP = 200
	if [[ $code -eq 200 ]]
	then

		#=== on récupère le texte de l'url (sans les balises html) avec la commande lynx (rare mais cela arrive)
		dump=$(lynx -dump -nolist -assume_charset=$charset -display_charset=$charset $URL)
		# -nolist : pour ne pas avoir une liste des urls


		#=== dans le cas des urls chinoises, il arrive que lynx récupère quelques caractères non utf-8
		#    on enlève ces caractères non utf-8 avec la commande iconv et l'option -c et on dump le texte dans le dossier ./dumps-text/
		if [[ $langue == "chinois" ]]
		then
			echo "$dump" > ./fichier.txt
			iconv -f utf-8 -t utf-8 -c ./fichier.txt > ./dumps-text/$basename-$lineno.txt
			dump=$(cat ./dumps-text/$basename-$lineno.txt)
			rm fichier.txt
		else
			echo "$dump" > ./dumps-text/$basename-$lineno.txt; # sinon on dump directement le texte dans le dossier ./dumps-text/
		fi
		
		#=== on aspire le contenu html de l'url et on dump le code dans le dossier ./aspirations/
		curl -Ls $URL > ./aspirations/$basename-$lineno.html;

		
		#=== si l'encodage du texte n'est pas UTF-8 et que le dump n'est pas vide, on le convertit en UTF-8
		if [[ $charset -ne "UTF-8" && -n "$dump" ]]
		then
			dump=$(echo "$dump" | iconv -f $charset -t UTF-8//IGNORE)
		fi


		#=== on récupère les occurences du mot que l'on a choisi grâce à notre expression régulière
		occurences=$(echo "$dump" | grep -Eo $regexp | wc -l)


		echo -e "\toccurences : $occurences"; # on print le nombre d'occurences dans le terminal
		

		#=== dans le cas des urls chinoises, il arrive que certains sites soient encodés en gbk,
		#    lynx ne prend pas en compte cette encodage, alors on utilise la commande w3m
		#    et on récupère le nouveau dump et les occurences
		if [[ ! occurences -ne 0 && $langue == "chinois" ]]
		then
			dump=$(w3m $URL)
			echo "$dump" > ./dumps-text/$basename-$lineno.txt;
			occurences=$(echo "$dump" | grep -Eo $regexp | wc -l)
			echo -e "\tnouvelles occurences : $occurences";
		fi


	#=== si le code HTTP n'est pas 200, on prend des variables vides pour éviter des résultats inattendus
	else
		echo -e "\tcode différent de 200 utilisation d'un dump vide";
		dump=""
		charset=""

	fi


	#=== on récupère trois lignes avant et après le mot choisi pour obtenir le contextes et on dump tout cela dans le dossier ./contextes/
	egrep -E -B3 -A3 $regexp ./dumps-text/$basename-$lineno.txt > ./contextes/$basename-$lineno.txt
	

	#=== on récupère les concordances de notre mot avec un fichier bash externe
	bash programmes/concordance.sh ./dumps-text/$basename-$lineno.txt $regexp $langue > ./concordances/$basename-$lineno.html

	
	#=== on print tout ce que l'on a trouvé en code html dans le fichier tableau, avec les liens vers les fichiers textes et html
	echo "<tr><td>$lineno</td><td>$code</td><td><a href=\"$URL\">$URL</a></td><td>$charset</td><td><a href="./urls/aspirations/$basename-$lineno.html">$basename-$lineno</a></td><td>$occurences</td><td><a href="./urls/contextes/$basename-$lineno.txt">$basename-$lineno</a></td><td><a href="./urls/concordances/$basename-$lineno.html">$basename-$lineno</a></tr>" >> $fichier_tableau
	echo -e "\t--------------------------------"
	

	#=== on rajoute 1 au compteur pour passer à l'url suivante
	lineno=$((lineno+1));


done < $fichier_urls # la boucle s'arrête ici


#=== print dans le fichier tableau la fin du code html
echo "</table>" >> $fichier_tableau
echo "</section>" >> $fichier_tableau