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


if [[ $langue == "chinois" ]] 
then
  python3 ./programmes/tokenize_chinese.py $fichier_texte > ./tokenized_1.txt
  sed "s/看\s书/看书/g" ./tokenized_1.txt > ./tokenized_2.txt
  fichier_texte=$(sed "s/[a-zA-Z0-9()-，；：！？。、&#]*//g" ./tokenized_2.txt)
fi

echo "$fichier_texte" | grep -Eo "(\w+\W+){0,5}\b($regexp)\b(\W+\w+){0,5}" | sed -E "s/(.*)($regexp)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/g"


echo "
</tbody>
</table>
</body>
</html>
"

rm ./tokenized_*.txt
