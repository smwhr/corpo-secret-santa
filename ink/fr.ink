=== init_fr
Votre mission, si vous l'acceptez, est de mener l'enquête : qui a offert quoi à qui au Petit Noël Secret de la COGIP ?

+ [Et quand j'ai tout trouvé ?]
-

Dès que vous en savez assez, quittez les locaux. Vous devrez répondre à quatre questions pour prouver que vous en savez assez.

-(opts)
* [Des conseils ?]
    C'est plus facile avec un papier et un crayon. Ou alors avec une feuille Excel. Sauf si vous êtes Einstein.
    ->opts
+ [C'est parti !]
-

-> loop_fr

=== loop_fr
+ [tag: alice Alice] 
    ALICE: Je m'appelle Alice.
    ALICE: David et moi avons la chance d'avoir chacun un bureau individuel.
    ALICE: J'ai reçu un cadeau de saison !
    ALICE: Je connais mal ceux de l'open-space alors j'ai offert un peit quelquechose de mon dernier voyage à l'étranger.
+ [tag: benjamin Benjamin] 
    BENJAMIN: Bonjour, moi c'est Benjamin.
    BENJAMIN: Je sais ce que ma voisin de gauche a offert, je l'ai vue passer commande sur internet.
    BENJAMIN: Chaque fois qu'un membre de l'équipe fait un voyage à l'étranger, il envoie une carte postale, c'est la tradition !
+ [tag: caroline Caroline] 
    CAROLINE: Salut, je suis Caroline.
    CAROLINE: J'ai acheté un cadeau de saison dans une petite boutique du centre ville.
    CAROLINE: Le cadeau que j'ai reçu est très joli. Une fois consommé ça fera une jolie déco sur mon bureau. D'ailleurs je l'y ai laissé.
    CAROLINE: Je me suis arrangée pour que personne ne reçoive un cadeau de la même personne à qui on l'offre.
+ [tag: david David] 
    DAVID: Moi c'est David.
    DAVID: Je ne savais pas vraiment où dépose mon cadeau, son destinataire n'a pas de bureau.
    DAVID: J'ai trouvé le mien sur mon bureau, il y est toujours.
    DAVID: C'est un cadeau de saison !
+ [tag: emily Émilie] 
    EMILY: Je m'appelle Émilie
    EMILY: C'est n'importe quoi d'offrir des choses à manger, on ne sait jamais avec les allergies et tout !
    EMILY: C'était très gênant de chercher un cadeau alors que je travaille avec le destinataire dans la même pièce toute la journée !
+ [tag: francis François] 
    FRANCIS: Bonjour, je suis François.
    FRANCIS: J'ai acheté mon cadeau en avance, cet été, pendant mon voyage. C'est une spécialité locale !
    FRANCIS: Je connais bien Émilie et le cadeau qu'elle a reçu ne colle pas du tout à ses principes.
+ [tag: geraldine Géraldine] 
    GERALDINE: Géraldine, enchantée.
    GERALDINE: J'adore offrir des cadeaux à faire soi-même.
    GERALDINE: J'ai offert son cadeau à la personne qui s'asseoit toujours en face de moi.
    GERALDINE: J'ai prêté le cadeau que j'ai reçu à une personne qui l'a posé sur son bureau.
+ [tag: hector Hector] 
    HECTOR: Salut, je suis Hector.
    HECTOR: Cette préparation pour cookie n'est pas à moi, on me l'a juste confiée. Cela dit, j'aurais préféré qu'on m'offre une gourmandise...
    HECTOR: J'ai offert un cadeau de saison.
+ [tag: isabella Isabella] 
    ISABELLA: Bonjour, je suis Isabella.
    ISABELLA: J'offre toujours des gourmandises ! Étant gourmande moi-même, je garde toujours quelques friandises dans le tiroir de mon bureau.
    ISABELLA: Si on m'avait consulté, j'aurais plutôt offert le cadeau sportif à François !
 

+ [tag: tea Thé]
    C'est une boîte de thé anglais richement décorée.
+ [tag: book Livre d'énigmes]
    C'est un livre rempli d'énigmes et de devinettes.
+ [tag: socks Chaussettes]
    Ce sont des chausettes. Sur la gauche, il y a un Père Noël et sur la droite un renne.
+ [tag: dumbbells Haltères]
    Ce sont des haltères. De 5kg d'après l'insription gravée.
+ [tag: lego Boîte de Lego]
    C'est une boîte de Lego pour construire un camion de glaces.
+ [tag: risotto Risotto]
    C'est un sachet de risotto, prêt à verser dans une poêle.
+ [tag: cookieprep Préparation Cookies]
    C'est un bocal contenant tous les ingrédients pour faire des cookies (sauf les oeufs). À l'arrière, un livret de recette donne des astuces pour qu'ils soient meilleurs.
+ [tag: chocolate Chocolats]
    C'est une boîte de chocolats en forme de sapin de Noël.
+ [tag: cottoncandy Saut de barbe à papa]
    Le saut est rempli de la mousse rose de la barbe à papa.
 
+ [tag: fridge Réfrigérateur]
    Aimantées sur le réfrigérateur, deux cartes postales : la première vient du Royaume-Uni et a un long message signé "E" ; la seconde est laconique, non-signée, vient d'Italie.
 
+ [tag: leave Quitter les bureaux]
    -> questionnaire_fr
    
-
-> loop_fr


=== questionnaire_fr
~temp score = 0
Première question: Qu'a reçu François ?
    + [Du thé]
    + [Un saut de barbe à papa]
    + [Une boîte de Lego]
        ~score+=1
    + [Des haltères de 5kg]
-
Deuxième question: Qui a offert la préparation pour cookies ?
    + [François]
    + [Isabella]
    + [Benjamin]
    + [Géraldine]
        ~score+=1
-
Troisième question: Qui a reçu le risotto ?
    + [Hector]
    + [David]
    + [Benjamin]
        ~score+=1
    + [Caroline]
-
Dernière question: Qu'a offert Isabella ?
    + [Un saut de barbe à papa]
        ~score+=1
    + [Un livre d'énigmes]
    + [Une boîte de chocolat]
    + [Une boîte de Lego]
-
{score==4: -> win_fr}
Désolé, vous n'avez répondu qu'à {score} questions correctement sur les 4.
Essayez de quitter les bureaux quand vous en saurez plus.

-> loop_fr
=== win_fr

Bravo, vous avez trouvé !

+ [Générique]
Tous les personnages et objets sont dessinés à la main par moi.
L'histoire/énigme aussi. À la main.
Assets 3D par Keney (Furniture Kit)
Merci à Robinson et Barnabé pour leur QA intensive.
Et bonnes fêtes !
-

->END