from nltk.tokenize import RegexpTokenizer
from stop_words import get_stop_words
from nltk.stem.porter import PorterStemmer
from gensim import corpora, models
import gensim

tokenizer = RegexpTokenizer(r'\w+')
en_stop = get_stop_words('en')
p_stemmer = PorterStemmer()

doc_set=[]

for i in range(1977,2015):
 print 'on ',str(i)
 with open('/home/raj/projects/topicModels/topics/'+str(i)+'.txt','r') as foo:
  doc_set.append(foo.read().replace('\n',''))

texts = []

for i in doc_set:
 raw = i.lower()
 tokens = tokenizer.tokenize(raw)
 stopped_tokens = [i for i in tokens if not i in en_stop]
 texts.append(stopped_tokens)

dictionary = corpora.Dictionary(texts)
corpus = [dictionary.doc2bow(text) for text in texts]

ldamodel = gensim.models.ldamodel.LdaModel(corpus, num_topics=10, id2word = dictionary, passes=20)
