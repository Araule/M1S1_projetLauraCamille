#!/usr/bin/env bash

#========================================================================================
# fichier_raw : chemin vers le corpus chinois avant tokenisation
# fichier_tokenized : chemin vers le corpus chinois tokenizé - n'existe pas encore
#========================================================================================


fichier_raw=$1
fichier_tokenized=$2


#=== on tokenise le corpus chinois
python3 ./tokenize_chinese.py $fichier_raw > ./fichier_1.txt
sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on recolle le verbe lire "看书"
sed "s/[a-zA-Z0-9()&#*<>=/_%.\"-]*//g" ./fichier_2.txt > $fichier_tokenized # on enlève quelques caractères inutiles
rm ./fichier_*.txt # on supprime les fichiers inutiles


echo -e "\nvous pouvez passer à la dernière partie en copiant la ligne de commande suivante"
echo -e "\tpython3 ./stopword.py"
