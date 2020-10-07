#!/usr/bin/env python3
#
# translate.py
#
# Simple command line tool to translate text from one language to another
# using the Google Translation API. Given a source text, return the translated
# text.
#
#   Ryan Cormier <rydcormier@gmail.com>
#   8/15/20

import getopt
import json
import os
import sys
import urllib.parse
import urllib.request


help_msg = """usage:  translate.py [options] (-t | --target) LANGUAGE [TEXT]

Options:

    --help, -h          Print this help message.
    --input, -i FILE    Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --output, -o FILE   Write target text to FILE.
    --source, -s LANG   Language or language code of source text. If not given,
                        the translator will try to determine the source language.
    --target, -t LANG   Language or Language code of the target text.
"""

# Provided API
API = {
'url': """https://translate.google.com/translate_a/single?client=at&dt=t&dt=\
ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b\
944-fa62-4b55-b330-74909a99969e&""",
'headers': {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent':
    'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1'},
'method': 'POST'
}

# Supported languages
LANGUAGES = (
    ('af', 'afrikaans'), ('sq', 'albanian'), ('am', 'amharic'), ('ar', 'arabic'),
    ('hy', 'armenian'), ('az', 'azerbaijani'), ('eu', 'basque'), ('be', 'belarusian'),
    ('bn', 'bengali'), ('bs', 'bosnian'), ('bg', 'bulgarian'), ('ca', 'catalan'),
    ('ceb', 'cebuano'), ('ny', 'chichewa'), ('zh-cn', 'chinese (simplified)'),
    ('zh-tw', 'chinese (traditional)'), ('co', 'corsican'), ('hr', 'croatian'),
    ('cs', 'czech'), ('da', 'danish'), ('nl', 'dutch'), ('en', 'english'),
    ('eo', 'esperanto'), ('et', 'estonian'), ('tl', 'filipino'), ('fi', 'finnish'),
    ('fr', 'french'), ('fy', 'frisian'), ('gl', 'galician'), ('ka', 'georgian'),
    ('de', 'german'), ('el', 'greek'), ('gu', 'gujarati'), ('ht', 'haitian creole'),
    ('ha', 'hausa'), ('haw', 'hawaiian'), ('iw', 'hebrew'), ('he', 'hebrew'),
    ('hi', 'hindi'), ('hmn', 'hmong'), ('hu', 'hungarian'), ('is', 'icelandic'),
    ('ig', 'igbo'), ('id', 'indonesian'), ('ga', 'irish'), ('it', 'italian'),
    ('ja', 'japanese'), ('jw', 'javanese'), ('kn', 'kannada'), ('kk', 'kazakh'),
    ('km', 'khmer'), ('ko', 'korean'), ('ku', 'kurdish (kurmanji)'), ('ky', 'kyrgyz'),
    ('lo', 'lao'), ('la', 'latin'), ('lv', 'latvian'), ('lt', 'lithuanian'),
    ('lb', 'luxembourgish'), ('mk', 'macedonian'), ('mg', 'malagasy'), ('ms', 'malay'),
    ('ml', 'malayalam'), ('mt', 'maltese'), ('mi', 'maori'), ('mr', 'marathi'),
    ('mn', 'mongolian'), ('my', 'myanmar (burmese)'), ('ne', 'nepali'),
    ('no', 'norwegian'), ('or', 'odia'), ('ps', 'pashto'), ('fa', 'persian'),
    ('pl', 'polish'), ('pt', 'portuguese'), ('pa', 'punjabi'), ('ro', 'romanian'),
    ('ru', 'russian'), ('sm', 'samoan'), ('gd', 'scots gaelic'), ('sr', 'serbian'),
    ('st', 'sesotho'), ('sn', 'shona'), ('sd', 'sindhi'), ('si', 'sinhala'),
    ('sk', 'slovak'), ('sl', 'slovenian'), ('so', 'somali'), ('es', 'spanish'),
    ('su', 'sundanese'), ('sw', 'swahili'), ('sv', 'swedish'), ('tg', 'tajik'),
    ('ta', 'tamil'), ('te', 'telugu'), ('th', 'thai'), ('tr', 'turkish'),
    ('uk', 'ukrainian'), ('ur', 'urdu'), ('ug', 'uyghur'), ('uz', 'uzbek'),
    ('vi', 'vietnamese'), ('cy', 'welsh'), ('xh', 'xhosa'), ('yi', 'yiddish'),
    ('yo', 'yoruba'), ('zu', 'zulu')
)

def canonizeLanguage(language):
    """If the given string is in LANGUAGES, return the language code, else
    an empty string.
    """
    for code, name in LANGUAGES:
        if language == code or language == name:
            return code
    return ''

def getOpts():
    """Process command line arguments and return a dict mapping of options."""
    # get arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'hi:jlo:s:t:',
            ['help', 'input=', 'json', 'list', 'output=', 'source=', 'target='])
    except GetoptError as e:
        return { 'error': e.msg }

    # parse opts and verify
    res = {}
    for o, a in opts:
        if o in ("-h", "--help"):
            return { 'help' : True }
        elif o in ("-i", "--input"):
            try:
                with open(a, 'r') as f:
                    res['text'] = ' '.join([l.strip() for l in f.readlines()])
            except Exception as e:
                return { 'error' : '{}'.format(e) }
        elif o in ('-j', '--json'):
            res['json'] = True
        elif o in ("-l", "--list"):
            return { "list" : True }
        elif o in ("-o", "--output"):
            # leave verification for later
            res['output'] = a
        elif o in ("-s", "--source"):
            # validate language
            if canonizeLanguage(a):
                res['source'] = canonizeLanguage(a)
            else:
                return { 'error': 'Unsupported language: {}'.format(a) }
        elif o in ("-t", "--target"):
            # validate language
            if canonizeLanguage(a):
                res['target'] = canonizeLanguage(a)
            else:
                return { 'error': 'Unsupported language: {}'.format(a) }
    # target is a required
    if 'target' not in res:
        return { 'error' : 'Required argument missing.' }
    # source is optional
    if 'source' not in res:
        res['source'] = 'auto'
    # if no input file given, text is the last argument
    if 'text' not in res:
        if not args:
            return { 'error' : 'No text given.'}
        res['text'] = args
    return res


def main():
    """Get options, make an HTTP request, parse the results and return the
    translation/transliteration.
    """

    opts = getOpts()
    if 'error' in opts:
        sys.stderr.write('Error: {}\n{}\n'.format(opts['error'], help_msg))
        sys.exit(1)
    if 'help' in opts:
        print(help_msg)
        sys.exit(0)
    if 'list' in opts:
        print('%-21s\t%s\n%-21s\t%s' % ('   Language', '  Code',
            '==============', '========'))
        for code, name in LANGUAGES:
            print('%-21s\t  %s' % (name, code))
        sys.exit(0)

    # encode data and use API to make HTTP request
    data = { 'sl': opts['source'], 'tl': opts['target'], 'q': opts['text'] }
    data = urllib.parse.urlencode(data).encode('utf-8')
    request = urllib.request.Request(API['url'],
        headers=API['headers'], data=data, method=API['method'])
    try:
        with urllib.request.urlopen(request) as response:
            translation = json.load(response)
    except Exception as e:
        sys.stderr.write('Unable to process HTTP request: {}\n'.format(e))
        sys.exit(1)

    if opts.get('json'):
        target = json.dumps(translation)
    else:
        # get 'trans' and 'translit' which are nested in 'sentences'
        sentences = translation.get('sentences', [])
        target = (''.join(s.get('trans', '') for s in sentences) + '\n' +
                  ''.join(s.get('translit', '') for s in sentences)).strip()

    if 'output' in opts:
        # output file has not been verified
        try:
            with open(opts['output'], 'w') as f:
                f.write(target)
        except:
            sys.stderr.write('Unable to write to {}\n'.format(opts['out']))
            sys.exit(1)
    else:
        print(target)
    sys.exit(0)


if __name__ == "__main__":
    main()
