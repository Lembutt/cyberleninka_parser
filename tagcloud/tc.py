import natasha
import collections
import csv

class TagCloud:
    def __init__(self, articles: list):
        my_tags = []
        counter = 0
        for a in articles:
            counter += 1
            print(counter)
            doc = natasha.Doc(a['annotation'])
            
            segmenter = natasha.Segmenter()
            emb = natasha.NewsEmbedding() 
            ner_tagger = natasha.NewsNERTagger(emb)
            morph_tagger = natasha.NewsMorphTagger(emb)
            morph_vocab = natasha.MorphVocab() 
            doc.segment(segmenter)
            doc.tag_morph(morph_tagger)
            doc.tag_ner(ner_tagger)
            for token in doc.tokens:
                if token.pos in ['NOUN', 'PROPN']:
                    token.lemmatize(morph_vocab)
                    my_tags.append(token.lemma)

        counted = collections.Counter(my_tags)
        sorted_counted = {key: value for key, value in sorted(counted.items(), key=lambda item: item[1])}
        with open('csv.csv', 'w') as f:
            writer = csv.writer(f, delimiter=';', quotechar='"')
            for key in sorted_counted.keys():
                writer.writerow([sorted_counted[key], key, '', ''])
        self.data_to_show = sorted_counted
