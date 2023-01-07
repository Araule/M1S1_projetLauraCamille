#!/usr/bin/env bash


#================================================================================
# fichier_texte -- path : # chemin vers le fichier du dossier ./dumps-text.txt
# fichier_texte -- str : dans le cas des urls chinoises, la variable contient 
# à la fin le texte du fichier
# regexp - str : contient l'expression régulière, change en fonction de la langue
# langue -- str : variable qui permet d'utiliser le fichier pour les 3 langues
#================================================================================


fichier_texte=$1 # chemin vers le fichier
regexp=$2 # expression régulière
langue=$3 # chinois, coreen ou francais


#=== on vérifie si les trois arguments sont bien là
if [[ $# -ne 3 ]] 
then
  echo "Ce programme demande exactement trois arguments."
  exit
fi


echo "
<!DOCTYPE html>
<html lang=\"ko\">
<head>
<meta charset=\"UTF-8\">
<title>Concordance</title>
</head>
<body>
<table>
<thead>
<tr>
<th class=\"has-text-left\">Contexte gauche</th>
<th>Cible</th>
<th class=\"has-text-right\">Contexte droit</th>
</tr>
</thead>
<tbody>
"

#=== dans le cas des urls chinoises, on doit tokenize les fichiers avant de récupérer les contextes
if [[ $langue == "chinois" ]]
then
  python3 ./programmes/tokenize_chinese.py $fichier_texte > ./fichier_1.txt # on tokenise
  sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on renverse la tokenisation du verbe lire 看书
  fichier_texte=$(sed "s/[a-zA-Z0-9()]*//g" ./fichier_2.txt) # on en profite pour enlever quelques caractères inutiles
  echo "$fichier_texte" | grep -Eo "(\w+\W+){0,5}\b($regexp)\b(\W+\w+){0,5}" | sed -E "s/(.*)($regexp)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/g"
  rm ./fichier_*.txt # on supprime les fichiers inutiles


#=== dans les autres cas, on va directement chercher les contextes
else
  grep -Eo "(\w+\W+){0,5}\b($regexp)\b(\W+\w+){0,5}" $fichier_texte | sed -E "s/(.*)($regexp)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/g"
fi


echo "
</tbody>
</table>
</body>
</html>
"
