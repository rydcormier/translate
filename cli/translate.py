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


help_msg = """usage:  translate.py [options] (-t | --target) <LANG> [TEXT]

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


def getOpts():
    """Process command line arguments and return a dict mapping of options."""
    # get arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'hi:lo:s:t:',
            ['help', 'input=', 'list', 'output=', 'source=', 'target='])
    except GetoptError as e:
        return { 'error': e.msg }
    # get supported languages: for now, load json file
    try:
        with open('languages.json', 'r') as f:
            data = json.load(f)
    except:
        return { 'error' : 'Unable to load language data.' }
    # parse opts and verify
    res = {}
    for o, a in opts:
        if o in ("-h", "--help"):
            return { 'help' : True }
        elif o in ("-l", "--list"):
            return { "list" : data }
        elif o in ("-i", "--input"):
            try:
                with open(a, 'r') as f:
                    res['text'] = ' '.join([l.strip() for l in f.readlines()])
            except Exception as e:
                return { 'error' : '{}'.format(e) }
        elif o in ("-o", "--output"):
            # leave verification for later
            res['output'] = a
        elif o in ("-s", "--source"):
            # make sure the language is supported
            if a in data['languages'] or a in data['langcodes']:
                res['source'] = a
            else:
                return { 'error': 'Unsupported language: {}'.format(a) }
        elif o in ("-t", "--target"):
            # verify language
            if a in data['languages'] or a in data['langcodes']:
                res['target'] = a
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
    translation"""

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
        for l, c in opts['list']['langcodes'].items():
            print('%-21s\t  %s' % (l, c))
        sys.exit(0)

    # encode data and use API to make HTTP request
    data = { 'sl': opts['source'], 'tl': opts['target'], 'q': opts['text'] }
    data = urllib.parse.urlencode(data).encode('ascii')
    request = urllib.request.Request(API['url'],
        headers=API['headers'], data=data, method=API['method'])
    try:
        with urllib.request.urlopen(request) as response:
            translation = json.load(response)
    except Exception as e:
        sys.stderr.write('Unable to process HTTP request: {}\n'.format(e))
        sys.exit(1)

    # we want the 'trans' items in 'sentences': watch for random brackets and quotes
    target = ' '.join(s['trans'].strip("' []") for s in translation['sentences'])
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
