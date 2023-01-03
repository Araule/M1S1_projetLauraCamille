#!/usr/bin/bash


fichier_texte=$1
motif=$2

if [[ $# -ne 2 ]]
then
  echo "Ce programme demande exactement deux arguments : "
  exit
fi

if [[ ! -f $fichier_texte ]]
then
  echo "le fichier $fichier_texte n'existe pas"
  exit
fi

if [[ -z $motif ]]
then
  echo "le motif est vide"
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

grep -E -o "(\w+\W+\w*){0,5}$motif(\w*\W+\w+){0,5}" $fichier_texte | sed -E "s/(.*)($motif)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/"
#compter les parenthèses et mettre ce chiffre à la place du \3
# n'a pas fonctionné car prend un nombre comme un un chiffre
#exemple \29 va me donner comme résultat "resultat du 2(donc le motif) + le chiffre 9 

echo "
</tbody>
</table>
</body>
</html>
"
