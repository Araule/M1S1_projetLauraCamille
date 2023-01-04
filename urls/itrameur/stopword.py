#!/usr/bin/env python
# coding: utf-8


import fileinput
import nltk
from nltk.corpus import stopwords


# on récupère d'abord le corpus
fichier = input("\nQuel est le nom du fichier tokenisé ? (ex. corpus_français.txt) : ")
with open(f"./{fichier}", 'r') as f :
    texte = f.read()
    liste_mots = texte.split()


# on demande la langue du texte pour avoir la liste des mots vides
langue = input("\nQuel est la langue du texte que vous voulez nettoyer ? (en anglais : french, chinese or korean) : ")
# il est important que la langue rentrée soit en anglais pour la suite
mots_vides = stopwords.words(langue)


# on récupère une liste sans les mots vides du corpus, puis on concatène les mots dans la variable texte_propre
liste_mots_pleins = []
for word in liste_mots :
    if langue == "french" : # si le texte est en français, il faut que tous les mots soient en minuscule
        word = word.lower()
    if word not in mots_vides : # si le mot ne figure pas dans la liste mots_vides, on le rajoute à liste_mots_pleins
        liste_mots_pleins.append(word)
texte_propre = " ".join(liste_mots_pleins)


# enfin, on écrit le texte dans un fichier
fichier_propre = input("\nQuel est le nom du fichier propre (ex. corpus_français_propre.txt) : ")
with open(f"./{fichier_propre}", 'w') as f :
    f.write(texte_propre)
