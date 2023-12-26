#!/usr/bin/env bash


#================================================================================
# le fichier est doit être appelé dans le dossier projet
# langue : variable qui permet d'utiliser le fichier pour les 3 langues
#================================================================================


langue=$1 # chinois, coreen ou francais


#=== on vérifie si les quatre arguments sont bien là
if [[ $# -ne 1 ]] 
then
  echo "Ce programme demande exactement 1 argument : la langue étudiée (chinois, francais ou coreen)."
  exit
fi


#=== on crée deux variables pour le code html qui suit
if [[ $langue == "chinois" ]]
then
  langue2="francais"
  langue3="coreen"
  regexp="看书|读书|阅读"
elif [[ $langue == "francais" ]]
then
  langue2="chinois"
  langue3="coreen" 
  regexp="lir\w+|lis\w+?|lis"
elif [[ $langue == "coreen" ]]
then
  langue2="francais"
  langue3="chinois" 
  regexp="읽[^지|기]\w+|읽지\s않는\w+|독서\w+"
else
  echo "La langue n'est pas reconnu par le fichier."
  exit
fi


for (( n=1; n<=50; n++ ))
do

  fichier_texte="./dumps-text/$langue-$n.txt"

  echo "<html style=\"background-color:F2F2F2;\">
  <head>
  <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css'>
  <link rel='stylesheet' href='assets/css/base.css'>
  <meta charset=\"UTF-8\">
  <title>Concordance</title>
  </head>
  <body>
  <nav class=\"navbar role=\"navigation\" aria-label=\"main navigation\" style=\"background-color:DAF7A6;\"\">
  <div class=\"navbar-brand\">
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Menu</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/tableaux.html\">Tableaux</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue2-1.html\">Concordance : $langue2</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue3-1.html\">Concordance : $langue3</a>
  </div>
  </div>
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Concordances 1 - 10</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-1.html\">$langue-1</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-2.html\">$langue-2</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-3.html\">$langue-3</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-4.html\">$langue-4</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-5.html\">$langue-5</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-6.html\">$langue-6</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-7.html\">$langue-7</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-8.html\">$langue-8</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-9.html\">$langue-9</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-10.html\">$langue-10</a>
  </div>
  </div>
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Concordances 11 - 20</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-11.html\">$langue-11</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-12.html\">$langue-12</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-13.html\">$langue-13</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-14.html\">$langue-14</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-15.html\">$langue-15</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-16.html\">$langue-16</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-17.html\">$langue-17</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-18.html\">$langue-18</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-19.html\">$langue-19</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-20.html\">$langue-20</a>
  </div>
  </div>
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Concordances 21 - 30</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-21.html\">$langue-21</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-22.html\">$langue-22</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-23.html\">$langue-23</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-24.html\">$langue-24</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-25.html\">$langue-25</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-26.html\">$langue-26</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-27.html\">$langue-27</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-28.html\">$langue-28</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-29.html\">$langue-29</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-30.html\">$langue-30</a>
  </div>
  </div>
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Concordances 31 - 40</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-31.html\">$langue-31</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-32.html\">$langue-32</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-33.html\">$langue-33</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-34.html\">$langue-34</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-35.html\">$langue-35</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-36.html\">$langue-36</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-37.html\">$langue-37</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-38.html\">$langue-38</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-39.html\">$langue-39</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-40.html\">$langue-40</a>
  </div>
  </div>
  <div class=\"navbar-item has-dropdown is-hoverable\">
  <a class=\"navbar-link\">Concordances 41 - 50</a>
  <div class=\"navbar-dropdown\">
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-41.html\">$langue-41</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-42.html\">$langue-42</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-43.html\">$langue-43</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-44.html\">$langue-44</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-45.html\">$langue-45</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-46.html\">$langue-46</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-47.html\">$langue-47</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-48.html\">$langue-48</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-49.html\">$langue-49</a>
  <a class=\"navbar-item\" href=\"https://araule.github.io/M1S1_projetLauraCamille/concordances/$langue-50.html\">$langue-50</a>
  </div>
  </div>
  </div>
  </nav>
  <section class=\"hero\" style=\"background-color:DAF7A6;\">
  <div class=\"hero-body\">
  <div class='block has-text-centered'>
  <p class='title is-2 has-is-centered'>Concordances : $langue-$n</p>
  <p class='title is-3 has-is-centered'>expression régulière : $regexp</p>
  </div>
  </div>
  </section>
  <section class='section mx-6 mt-5 mb-6'>
  <table class='table is-bordered is-striped is-fullwidth'>
  <thead>
  <tr><th class=\"has-text-right\">Contexte gauche</th><th class=\"has-text-centered\">Cible</th><th class=\"has-text-left\">Contexte droit</th></tr>
  </thead>
  <tbody>" > ./concordances/$langue-$n.html

  #=== dans le cas des urls chinoises, on doit tokenize les fichiers avant de récupérer les contextes
  if [[ $langue == "chinois" ]]
  then
    python3 ./scripts/tokenize_chinese.py $fichier_texte > ./fichier_1.txt # on tokenise
    sed "s/看\s书/看书/g" ./fichier_1.txt > ./fichier_2.txt # on renverse la tokenisation du verbe lire 看书
    fichier_texte=$(sed "s/[a-zA-Z0-9()]*//g" ./fichier_2.txt) # on en profite pour enlever quelques caractères inutiles
    echo "$fichier_texte" | grep -Eo "(\w+\W+){0,5}\b($regexp)\b(\W+\w+){0,5}" | sed -E "s/(.*)($regexp)(.*)/<tr><td class=\"has-text-right\">\1<\/td><td class=\"has-text-centered\">\2<\/td><td class=\"has-text-left\">\3<\/td><\/tr>/g" >> ./concordances/$langue-$n.html
    rm ./fichier_*.txt # on supprime les fichiers inutiles

  #=== dans les autres cas, on va directement chercher les contextes
  else
    grep -Eo "(\w+\W+){0,5}\b($regexp)\b(\W+\w+){0,5}" $fichier_texte | sed -E "s/(.*)($regexp)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/g" >> ./concordances/$langue-$n.html
  fi

  echo "</tbody>
  </table>
  </section>
  </body>
  </html>" >> ./concordances/$langue-$n.html

done