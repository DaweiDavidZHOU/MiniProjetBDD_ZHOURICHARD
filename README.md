Mini-projet : Conception et développement d’une base de données 
Présentation
Ce mini-projet reprend toutes les étapes de la méthode MERISE vues dans ce module et utilisées dans l’industrie pour la conception et le développement d’une base de données. A partir d’un domaine qui vous intéresse, vous allez construire votre base de données en suivant les étapes suivantes :

Etape 1 : Analyser les besoins
• Choisir un domaine qui vous intéresse
• Utiliser l’IAG pour obtenir des informations sur les règles métier de votre domaine, et les
données à stocker

Etape 2 : MCD
• A partir des données obtenues à l’étape 1, produire le MCD
• Il doit être normalisé et inclure des éléments avancés de modélisation

Etape 3 : MLD et MLP
• A partir du MCD, récupérer le MLD et MPD en SQL
• Définir les contraintes additionnelles et le code SQL correspondant

Etape 4 : Insérer des données
• Remplir la base de données en s’aidant de l’IAG
• S’assurer du respect des contraintes d’intégrité des données générées

Etape 5 : Interroger la base
• Imaginer un scénario d’utilisation de votre BD
• Ecrire les requêtes SQL DML correspondant à ce scénario

Etape 6 : Présentation
• Présentation de votre travail à travers une vidéo
• Explication des choix de modélisation et d’utilisation de la BD


Réponse que l'on a obtenue de l'IAG :
1. Contexte de l'organisation et de son activité. Je suis responsable de la gestion des données au sein de l’Observatoire National des Boissons et de la Consommation Alcoolisée, établissement public à vocation de référence. Notre mission consiste à collecter, centraliser, vérifier, conserver et mettre à disposition des données fiables et à jour sur l’ensemble du secteur des boissons alcoolisées, en France et à l’international.
Nos sources s’appuient sur des institutions reconnues : l’Organisation Internationale de la Vigne et du Vin (OIV), l’Institut National de l’Origine et de la Qualité (INAO), l’Office National des Vins et des Spiritueux, l’INSEE, les services statistiques des ministères ainsi que les textes officiels consultables sur Légifrance. Nous couvrons plusieurs domaines : la classification des boissons, les caractéristiques de chaque produit, l’identification et la localisation des producteurs, les appellations d’origine et aires géographiques délimitées, les informations sur les pays et leurs populations, la réglementation applicable à chaque territoire, les relations entre produits (comp
osition, boissons dérivées) et enfin les statistiques annuelles de consommation.
Les données servent à produire des états, des comparaisons, des suivis réglementaires et des publications statistiques ; elles doivent être cohérentes, vérifiées et traçables.
2. Règles de gestion des données (langage métier)
Chaque catégorie de boissons dispose d’un nom unique et d’une description ; elle peut être subdivisée en sous-catégories, elles-mêmes identifiées de manière unique.
Chaque boisson est rattachée à une seule sous-catégorie ; elle porte un nom et comporte au minimum son degré d’alcool volumique.
Le degré d’alcool est exprimé en pourcentage volumique, il est supérieur à 0 et inférieur ou égal à 100.
Le millésime correspond à l’année de récolte principale des matières premières ; il peut ne pas exister pour certaines boissons.
La durée de vieillissement est indiquée en unités de temps (généralement années) si elle est imposée ou mentionnée dans la définition du produit.
Chaque producteur est identifié par un nom légal, un numéro d’identification unique et une adresse d’implantation principale.
La localisation du producteur inclut la commune, le code postal, la région et le pays d’implantation.
Le pays est identifié par son nom officiel et son code ISO 3166-1 alpha-2 sur 2 caractères, qui est unique.
Une appellation d’origine est un nom protégé, unique, rattachée à une région de production délimitée et à un seul pays.
La région de production comporte un nom et peut être subdivisée en zones plus précises ; elle est située dans un pays.
La population d’un pays est exprimée en nombre d’habitants et est associée à une année de référence.
L’âge minimum légal d’achat ou de consommation est défini par pays et peut être différent selon le type de boisson ; il est exprimé en années révolues.
Le taux de taxation s’applique par catégorie de boissons dans un pays donné ; il peut être un pourcentage du prix ou une valeur par unité de volume.
Lorsqu’une boisson est composée d’autres boissons, chaque ingrédient est identifié et la proportion utilisée est indiquée si elle est connue.
Une boisson dérivée est issue de la transformation d’une boisson de base ; le lien entre la boisson d’origine et la boisson obtenue est conservé.
Les statistiques de consommation portent sur une boisson ou une catégorie, un pays et une année précise ; elles indiquent un volume total consommé.
La source de chaque donnée statistique est indiquée avec sa date de publication pour garantir la traçabilité.
Toute donnée est datée de sa mise à jour dans l’observatoire ; une mention indique si elle est provisoire ou définitive.
Les codes pays sont systématiquement conformes à la norme ISO 3166-1 alpha-2 et ne sont pas modifiés.
Les noms d’appellation sont saisis conformément à la dénomination officielle publiée par l’autorité compétente.
Il n’existe pas de doublon dans l’identification des producteurs, des appellations et des catégories.
Les valeurs numériques (degré, volume, population, âge) sont contrôlées pour être cohérentes et non négatives, sauf cas explicitement admis.
Une boisson ne peut être rattachée qu’à une seule sous-catégorie à un instant donné.
Une appellation ne peut être rattachée qu’à une seule région de production.
Les statistiques de consommation sont publiées par année civile et ne sont pas fusionnées sur plusieurs années sans mention explicite.
3. Dictionnaire de données brutes
Table
N°	Signification de la donnée	Type attendu	Taille / format / plage de valeurs
1	Nom de la catégorie de boissons	Texte	2 à 80 caractères, unique
2	Description de la catégorie	Texte	Jusqu’à 500 caractères
3	Nom de la sous-catégorie de boissons	Texte	2 à 80 caractères, unique
4	Nom de la boisson	Texte	2 à 120 caractères
5	Degré d’alcool volumique	Nombre (décimal)	0,1 à 100,0 ; 1 chiffre après la virgule
6	Millésime — année de récolte	Nombre (année)	4 chiffres, ex : 2024 ; peut être vide
7	Durée réglementaire de vieillissement	Nombre entier	1 à 50 (en années) ; peut être vide
8	Unité de temps du vieillissement	Texte	« année », « mois », « jour » ; peut être vide
9	Nom légal du producteur	Texte	3 à 150 caractères
10	Numéro d’identification du producteur	Texte	9 à 15 caractères, format national (ex: SIRET)
11	Commune d’implantation du producteur	Texte	2 à 80 caractères
12	Code postal du producteur	Texte	5 caractères pour la France ; adapté selon pays
13	Région d’implantation du producteur	Texte	2 à 80 caractères
14	Nom officiel du pays	Texte	3 à 80 caractères
15	Code du pays selon norme ISO 3166-1 alpha-2	Texte	Exactement 2 caractères, majuscules (ex: FR, DE)
16	Nom de la région de production	Texte	2 à 80 caractères
17	Nom de l’appellation d’origine protégée	Texte	3 à 120 caractères, unique
18	Superficie de l’aire de l’appellation	Nombre entier	En hectares ; ≥ 0 ; peut être vide
19	Population totale du pays	Nombre entier	≥ 0
20	Année de référence de la population	Nombre (année)	4 chiffres
21	Âge minimum légal d’achat	Nombre entier	12 à 21 ans
22	Type de boisson concerné par l’âge minimum	Texte	« toute boisson », « vin », « bière », « spiritueux »
23	Taux de taxation applicable	Nombre (décimal)	≥ 0 ; en % ou en EUR/litre selon nature
24	Nature du taux de taxation	Texte	« ad valorem », « spécifique »
25	Nom de la boisson ingrédient	Texte	Référence à une boisson existante
26	Proportion de l’ingrédient dans la composition	Nombre (décimal)	0,1 à 100,0 % ; peut être vide
27	Nom de la boisson d’origine pour produit dérivé	Texte	Référence à une boisson existante
28	Volume total consommé sur l’année	Nombre entier	En litres ; ≥ 0
29	Année des données de consommation	Nombre (année)	4 chiffres
30	Nom de la source des données de consommation	Texte	5 à 150 caractères
31	Date de publication de la source	Date	Format AAAA-MM-JJ
32	Statut de la donnée	Texte	« provisoire », « définitive »
33	Date de dernière mise à jour dans l’observatoire	Date	Format AAAA-MM-JJ
Nombre de données distinctes : 33 — conforme à la fourchette demandée (25–35).
Aucune structure de table ni relation n’a été créée : seul le niveau des données brutes est présent, comme demandé.
