#!/usr/bin/env bash


fichier_texte=$1
regexp=$2
langue=$3



if [[ ! -f $fichier_texte ]]
then
  echo "le fichier $fichier_texte n'existe pas";
  exit
fi

if [[ -z $regexp ]]
then
  echo "le motif est vide";
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


if [[ $langue == "chinois" ]] # pour les dumps chinois
then
  python3 ./programmes/tokenize_chinese.py $fichier_texte > ./fichier_1.txt # on tokenise
  sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on renverse la tokenisation du verbe lire 看书
  fichier_texte=$(sed "s/[a-zA-Z0-9()&#*<>=§/_%.\"-+]*//g" ./fichier_2.txt) # on en profite pour enlever quelques caractères inutiles pour la concordance
fi

echo $fichier_texte | grep -Eo "(\w+\W+){0,5}($regexp)(\W+\w+){0,5}" | sed -E "s/(.*)($regexp)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/g"


echo "
</tbody>
</table>
</body>
</html>
"

# on supprime les fichiers inutiles
rm ./fichier_*.txt
