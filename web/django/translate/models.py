# translate/models.py
import json
import urllib

from django.db import models


# supported languages
LANGUAGES = ( ('auto', 'detect language'),
    ('af', 'afrikaans'), ('sq', 'albanian'), ('am', 'amharic'),
    ('ar', 'arabic'), ('hy', 'armenian'), ('az', 'azerbaijani'),
    ('eu', 'basque'), ('be', 'belarusian'), ('bn', 'bengali'),
    ('bs', 'bosnian'), ('bg', 'bulgarian'), ('ca', 'catalan'),
    ('ceb', 'cebuano'), ('ny', 'chichewa'), ('zh-cn', 'chinese (simplified)'),
    ('zh-tw', 'chinese (traditional)'), ('co', 'corsican'), ('hr', 'croatian'),
    ('cs', 'czech'), ('da', 'danish'), ('nl', 'dutch'), ('en', 'english'),
    ('eo', 'esperanto'), ('et', 'estonian'), ('tl', 'filipino'),
    ('fi', 'finnish'), ('fr', 'french'), ('fy', 'frisian'), ('gl', 'galician'),
    ('ka', 'georgian'), ('de', 'german'), ('el', 'greek'), ('gu', 'gujarati'),
    ('ht', 'haitian creole'), ('ha', 'hausa'), ('haw', 'hawaiian'),
    ('iw', 'hebrew'), ('he', 'hebrew'), ('hi', 'hindi'), ('hmn', 'hmong'),
    ('hu', 'hungarian'), ('is', 'icelandic'), ('ig', 'igbo'),
    ('id', 'indonesian'), ('ga', 'irish'), ('it', 'italian'),
    ('ja', 'japanese'), ('jw', 'javanese'), ('kn', 'kannada'), ('kk', 'kazakh'),
    ('km', 'khmer'), ('ko', 'korean'), ('ku', 'kurdish (kurmanji)'),
    ('ky', 'kyrgyz'), ('lo', 'lao'), ('la', 'latin'), ('lv', 'latvian'),
    ('lt', 'lithuanian'), ('lb', 'luxembourgish'), ('mk', 'macedonian'),
    ('mg', 'malagasy'), ('ms', 'malay'), ('ml', 'malayalam'), ('mt', 'maltese'),
    ('mi', 'maori'), ('mr', 'marathi'), ('mn', 'mongolian'),
    ('my', 'myanmar (burmese)'), ('ne', 'nepali'), ('no', 'norwegian'),
    ('or', 'odia'), ('ps', 'pashto'), ('fa', 'persian'), ('pl', 'polish'),
    ('pt', 'portuguese'), ('pa', 'punjabi'), ('ro', 'romanian'),
    ('ru', 'russian'), ('sm', 'samoan'), ('gd', 'scots gaelic'),
    ('sr', 'serbian'), ('st', 'sesotho'), ('sn', 'shona'), ('sd', 'sindhi'),
    ('si', 'sinhala'), ('sk', 'slovak'), ('sl', 'slovenian'), ('so', 'somali'),
    ('es', 'spanish'), ('su', 'sundanese'), ('sw', 'swahili'),
    ('sv', 'swedish'), ('tg', 'tajik'), ('ta', 'tamil'), ('te', 'telugu'),
    ('th', 'thai'), ('tr', 'turkish'), ('uk', 'ukrainian'), ('ur', 'urdu'),
    ('ug', 'uyghur'), ('uz', 'uzbek'), ('vi', 'vietnamese'), ('cy', 'welsh'),
    ('xh', 'xhosa'), ('yi', 'yiddish'), ('yo', 'yoruba'), ('zu', 'zulu')
)

# API
URL = """https://translate.google.com/translate_a/single?client=at&dt=t&dt=\
ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b\
944-fa62-4b55-b330-74909a99969e&"""

HEADERS = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent':
    'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1'
}


class Translation(models.Model):
    """A translation consists of the source language, the target language,
    the input text, and the output text.
    """
    input = models.TextField()
    output = models.TextField(blank=True)
    source = models.CharField(max_length=5, choices=LANGUAGES, default='auto')
    target = models.CharField(max_length=5, choices=LANGUAGES[1:])

    def translate(self):
        """Retrieves the translation and transliteration if it exists."""
        data = {'sl': self.source, 'tl': self.target, 'q': self.input}
        data = urllib.parse.urlencode(data).encode('utf-8')

        # build the request
        request = urllib.request.Request(URL, headers=HEADERS, data=data, method="POST")

        # the response comes as json
        res = None
        with urllib.request.urlopen(request) as response:
            res = json.load(response)

        # something went wrong
        if not res:
            return

        sentences = res.get('sentences', [])
        trans = ''.join( [s.get('trans', '') for s in sentences ])
        trans += '\n\n' + ''.join([ s.get('translit', '') for s in sentences ])

        # the ! character is sometimes tricky
        trans.replace(chr(65281), chr(33))

        self.output = trans.strip()
