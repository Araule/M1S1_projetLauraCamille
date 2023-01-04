#!/usr/bin/env bash

###################################################
#
# Ce fichier bash est à utiliser directement dans
# le dossier itrameur.
#
###################################################


nom_fichier_raw=$1
nom_fichier_tokenized=$2
nom_fichier_final=$3


# d'abord on tokenise le fichier
python3 ./tokenize_chinese.py ./$nom_fichier_raw.txt > ./fichier_1.txt
sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on recolle le verbe lire "看书"
sed "s/[a-zA-Z0-9()&#*<>=§/_%.\"-]*//g" ./fichier_2.txt > ./$nom_fichier_tokenized.txt # on enlève quelques caractères inutiles

# on supprime les fichiers inutiles
rm ./fichier_*.txt

# ensuite on enlève les mots vides et on les dump dans un fichier final
touch ./$nom_fichier_final.txt
echo "vous pouvez passer à la dernière partie en copiant la ligne de commande suivante"
echo "python3 ./stopword.py"