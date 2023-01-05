#!/usr/bin/env python
# coding: utf-8


import fileinput
import nltk
from nltk.corpus import stopwords


# on récupère d'abord le corpus
fichier = input("\nQuel est le nom du fichier tokenisé ? (ex. ./contextes-chinois-tokenized.txt) : ")
with open(fichier, 'r') as f :
    texte = f.read()
    liste_mots = texte.split()


# on demande la langue du texte pour avoir la liste des mots vides
langue = input("\nQuel est la langue du texte que vous voulez nettoyer ? (en anglais : french, chinese or korean) : ")
# il est important que la langue rentrée soit en anglais pour la suite

# fichier texte stopwords_chinois.txt trouvé sur : https://github.com/goto456/stopwords + quelques ajouts personnels
# la liste de mots vides avec nltk n'était pas suffisante
# fichier texte stopwords_coreen.txt trouvé sous le nom de 'stopwords-ko.txt' sur : https://gist.github.com/spikeekips/40eea22ef4a89f629abd87eed535ac6a + ajouts personnels
if langue == "chinese" :
    with open("./stopwords_chinois.txt", 'r') as f :
        texte_motsvides = f.read()
    mots_vides = []
    for mot in texte_motsvides :
        mots_vides.append(mot)
else :
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
fichier_propre = input("\nQuel est le nom du fichier propre (ex. ./contextes-chinois-final.txt) : ")
with open(fichier_propre, 'w') as f :
    f.write(texte_propre)
