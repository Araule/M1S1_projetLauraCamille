#!/usr/bin/env python
# coding: utf-8


#=== ce fichier sert à enlever les mots vides de n'importe quel corpus français, chinois ou coréen


#=== on récupère d'abord tous les mots du corpus dans liste_mots
fichier = input("\nQuel est le nom du fichier à nettoyer ? (ex. ./contextes-chinois-tokenized.txt) : ")
with open(fichier, 'r') as f :
    texte = f.read()
    liste_mots = texte.split()


#=== on demande la langue du texte pour avoir la liste des mots vides
langue = input("\nQuel est la langue du texte à nettoyer ? (chinois, coréen ou français) : ")


# fichier texte stopwords_chinois.txt trouvé sur : https://github.com/goto456/stopwords + quelques ajouts personnels
# fichier texte stopwords_coreen.txt trouvé sur : https://gist.github.com/spikeekips/40eea22ef4a89f629abd87eed535ac6a + ajouts personnels
# fichier texte stopword_francais.txt trouvé sur : https://github.com/stopwords-iso/stopwords-fr/blob/master/stopwords-fr.txt

#=== on récupère dans la liste mots_vides tous les mots se trouvant dans l'un des fichiers textes
if langue == "chinois" :
    with open("./stopwords_chinois.txt", 'r') as f :
        texte_motsvides = f.read()
    mots_vides = []
    for mot in texte_motsvides :
        mots_vides.append(mot)
elif langue == "coréen" :
    with open("./stopwords_coreen.txt", 'r') as f :
        texte_motsvides = f.read()
    mots_vides = []
    for mot in texte_motsvides :
        mots_vides.append(mot)
else :
    with open("./stopwords_francais.txt", 'r') as f :
        texte_motsvides = f.read()
    mots_vides = []
    for mot in texte_motsvides :
        mots_vides.append(mot)


#=== on récupère une liste des mots du corpus sans les mots vides, puis on concatène les mots dans la variable str texte_propre
liste_mots_pleins = []
for word in liste_mots :
    if langue == "french" : # si le texte est en français, il faut que tous les mots soient en minuscule
        word = word.lower()
    if word not in mots_vides : # si le mot ne figure pas dans la liste mots_vides, on le rajoute à liste_mots_pleins
        liste_mots_pleins.append(word)
texte_propre = " ".join(liste_mots_pleins)


#=== enfin, on écrit le texte dans un fichier propre
fichier_propre = input("\nQuel est le nom du fichier propre ? (ex. ./contextes-chinois-final.txt) : ")
with open(fichier_propre, 'w') as f :
    f.write(texte_propre)
