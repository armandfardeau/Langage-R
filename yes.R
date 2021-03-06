# -*- coding: utf-8 -*-
#Chargement des packages: 
library (NLP)
library (tm)
library (SnowballC)
library (RColorBrewer)
library (wordcloud)

# lIRE UN FICHIER CSV 
data <- read.csv ("C:/Users/LENOVO PC/Desktop/TXM/identitenumerique.csv", header = TRUE, sep = ",", quote= "\"", encoding = "UTF-8" , stringsAsFactors = FALSE, strip.white= TRUE, blank.lines.skip = TRUE)
# data <- readLines () #Optionnel 

# Transformer les caractères accentués en version non accentués 
iconv (data, from = "UTF-8", to = "ASCII//TRANSLIT", sub = NA, mark = TRUE, toRaw = FALSE)

#data <- data.frame (keyword = rep( data))



#Création d'un Corpus 

data.corpus <- Corpus(VectorSource(data))

# Réduire la taille de corpus en effectuant des transformations

#data.corpus <- str_replace_all(data.corpus, "é", "e") #à ne pas utiliser les deux à la fois 

#toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
#data.corpus <- tm_map(data.corpus, toSpace, "@")
#data.corpus <- tm_map(data.corpus, toSpace, "'")




# Convertir le texte en minuscule 
#data.corpus <- tm_map(data.corpus, content_transformer(tolower))
 
# Supprimer les nombres 
data.corpus <- tm_map(data.corpus, removeNumbers)
# Supprimer les ponctuations 
data.corpus <- tm_map(data.corpus, removePunctuation) 
# Supprimer les mots vides français
data.corpus <- tm_map(data.corpus, function (x) removeWords(x, stopwords("french")))
# Supprimer votre propre liste de mots non désirés 
data.corpus <- tm_map(data.corpus, removeWords, c("vous")) 
#Supprimer les espaces vides supplémentaires 
data.corpus<- tm_map(data.corpus, stripWhitespace) 
# Text stemming 
data.corpus <- tm_map(data.corpus, stemDocument, language = "french")


# Construire la matrcie des mots 
data.tdm <- TermDocumentMatrix(data.corpus)
#data.tdm <- removeSparseTerms(data.tdm, 0995)

# Tranformer ce tdm en matrice 
data.m <- as.matrix(data.tdm)
# Classer en ordre décroissant les termes 
data.v <- sort(rowSums(data.m),decreasing=TRUE) 
# Calculer la fréquence de chaque mot 
data.d <- data.frame(word = names(data.v),freq=data.v)
#Choisir combien de mots (optionnel) 
#head(data.d, 50)

	
# Générer une palette de 5 couleurs 	
pal <- rev (brewer.pal(10, "RdYlBu"))

# Mettre le fond de l'image grise 
par (bg = "grey")

# Création de Wordcloud (Nuage de mots) 
wordcloud(words = data.d$word, data.d$freq, scale = c(8,0.5), min.freq = 2, max.words=200, random.order=FALSE, rot.per=0.35, colors = pal)

# Création de Wordcloud (Nuage de mots)
#svg("wordcloud.svg", width = 11, height = 11, bg = "grey")
#wordcloud(words = data.d$word, data.d$freq, scale = c(8,0.5), min.freq = 2, max.words=200, random.order=FALSE, rot.per=0.35, colors = pal)

#set.seed(1234)
#wordcloud(words = data.d$word, freq = data.d$freq, min.freq = 1,max.words=2000, random.order=FALSE, rot.per=0.35,colors=brewer.pal(8, "Dark2"))

