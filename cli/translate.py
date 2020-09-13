#!/usr/bin/python3
#
# translate.py
#
# Simple command line tool to translate text from one language to another
# using the Google Translation API. Given a source text, return the translated
# text.
#

from getopt import getopt, GetoptError
import json.load
import urllib
import os
import sys


help_msg = """usage:  translate.py [options] --targ <LANG> [TEXT]

Options:

    --help, -h          Print this help message.
    --infile, -i FILE   Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --outfile, -o FILE  Write target text to FILE.
    --src, -s LANG      Language or language code of source text. If not given,
						the translator will try to determine the source language.
    --targ, -t LANG     Language or Language code of the target text.
"""

# Provided API
URL = """https://translate.google.com/translate_a/single?client=at&dt=t&dt=\
ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b\
944-fa62-4b55-b330-74909a99969e&"""

HEADER = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent':
    'AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1'
}

METHOD = 'POST'




def get_opts():
	"""Process and return command line options as a dict object."""
	# get language data
	data = get_lang_data()

	try:
		opts, args = getopt.getopt(
			sys.argv[ 1 : ],
			'hi:lo:s:t:',
			[ 'help', 'infile=', 'list', 'outfile=', 'src=', 'targ=' ])
	except  GetoptError as e:
		return { 'error ': e}
	for o, a in opts:
		try:
			if o in ("-h", "--help"):
				return { 'help' : True }
			elif o in ("-l", "--list"):
				return { 'list': LanguageSupport.languages()}
			elif o in ("-i", "--infile"):
				pass # check if readabel
			elif o in ("-o", "--outfile"):
				pass # check permissions
			elif o in ("-t", "--targ"):
				pass
			elif o in ("-s", "--src"):
				pass
		except Exception as e:
			return { 'error': e }

	# Verify that the opts are valid
	if 'targ' not in opts:
		return {'error': LanguageError('No target language given')}
	if 'src' not in opts:
		opts['src'] = 'auto'

	return opts

def get_request(source, target, text):
    # define and encode request data
    data = { 'sl': source, 'tl': target, 'q': text }
    data = urllib.parse.urlencode(data).encode('ascii')

    # return Request object
    return urllib.request.Request(URL, header=HEADER, data=data, method=METHOD)


# Process command line arguments and request translation from Google. Exits
# with 0 on success and 1 otherwise.
def main() :
    ## get options
	opts = get_opts()

	if 'error' in opts:
		sys.stderr.write(str(e) + '\n' + help_msg +'\n')
		sys.exit(1)

	if 'list' in opts:
		for l, c in opts['list']:
			print('%-21s  %s\n' % (l, c))
			sys.exit(0)

	if 'help' in opts:
		print(help_msg)
		sys.exit(0)

    obj = {}
	target = ''
    kwargs = {'source': opts['src'], 'target': opts['targ'], 'text', opts['text'] }
    try:
        request = get_request(**kwaargs)
        with urllib.request.urlopen(request) as resp:
            data = json.load(resp)

        target = ' '.join(s['trans'] for s in data[sentences])

        if 'ofile' in opts:
            with open(opts['ofile'], 'w') as f:
                f.write(target)
        else:
            print(target)
    except PermissionError:
        sys.stderr.write('Unable to write to ' + opts['ofile'] + '\n')
        sys.exit(1)
    except:
        sys.stderr.write('HTTP error\n')
        sys.exit(1)
    sys.exit(0)



if __name__ == '__main__' :
    main()
