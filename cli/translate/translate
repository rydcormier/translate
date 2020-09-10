#!/usr/bin/python3
#
# translate.py
#
# Simple command line tool to translate text from one language to another
# using the Google Translation API. Given a source text, return the translated
# text.
#

import getopt
import json
import os
import sys

# supported language codes
LANGUAGES = {
        'af' : 'afrikaans', 'sq' : 'albanian', 'am' : 'amharic',
        'ar' : 'arabic', 'hy' : 'armenian', 'az' : 'azerbaijani',
        'eu' : 'basque', 'be' : 'belarusian', 'bn' : 'bengali',
        'bs' : 'bosnian', 'bg' : 'bulgarian', 'ca' : 'catalan',
        'ceb' : 'cebuano', 'ny' : 'chichewa', 'zh-cn' : 'chinese (simplified)',
        'zh-tw' : 'chinese (traditional)', 'co' : 'corsican', 'hr' : 'croatian',
        'cs' : 'czech', 'da' : 'danish', 'nl' : 'dutch', 'en' : 'english',
        'eo' : 'esperanto', 'et' : 'estonian', 'tl' : 'filipino',
        'fi' : 'finnish', 'fr' : 'french', 'fy' : 'frisian', 'gl' : 'galician',
        'ka' : 'georgian', 'de' : 'german', 'el' : 'greek', 'gu' : 'gujarati',
        'ht' : 'haitian creole', 'ha' : 'hausa', 'haw' : 'hawaiian',
        'iw' : 'hebrew', 'he' : 'hebrew', 'hi' : 'hindi', 'hmn' : 'hmong',
        'hu' : 'hungarian', 'is' : 'icelandic', 'ig' : 'igbo',
        'id' : 'indonesian', 'ga' : 'irish', 'it' : 'italian',
        'ja' : 'japanese', 'jw' : 'javanese', 'kn' : 'kannada', 'kk' : 'kazakh',
        'km' : 'khmer', 'ko' : 'korean', 'ku' : 'kurdish (kurmanji)',
        'ky' : 'kyrgyz', 'lo' : 'lao', 'la' : 'latin', 'lv' : 'latvian',
        'lt' : 'lithuanian', 'lb' : 'luxembourgish', 'mk' : 'macedonian',
        'mg' : 'malagasy', 'ms' : 'malay', 'ml' : 'malayalam', 'mt' : 'maltese',
        'mi' : 'maori', 'mr' : 'marathi', 'mn' : 'mongolian',
        'my' : 'myanmar (burmese)', 'ne' : 'nepali', 'no' : 'norwegian',
        'or' : 'odia', 'ps' : 'pashto', 'fa' : 'persian', 'pl' : 'polish',
        'pt' : 'portuguese', 'pa' : 'punjabi', 'ro' : 'romanian',
        'ru' : 'russian', 'sm' : 'samoan', 'gd' : 'scots gaelic',
        'sr' : 'serbian', 'st' : 'sesotho', 'sn' : 'shona', 'sd' : 'sindhi',
        'si' : 'sinhala', 'sk' : 'slovak', 'sl' : 'slovenian', 'so' : 'somali',
        'es' : 'spanish', 'su' : 'sundanese', 'sw' : 'swahili',
        'sv' : 'swedish', 'tg' : 'tajik', 'ta' : 'tamil', 'te' : 'telugu',
        'th' : 'thai', 'tr' : 'turkish', 'uk' : 'ukrainian', 'ur' : 'urdu',
        'ug' : 'uyghur', 'uz' : 'uzbek', 'vi' : 'vietnamese', 'cy' : 'welsh',
        'xh' : 'xhosa', 'yi' : 'yiddish', 'yo' : 'yoruba', 'zu' : 'zulu'
}

help_msg = """usage:  translate.py [options] -s|--src <LANG> -t|--targ <LANG> [TEXT]

Options:

    --help, -h          Print this help message.
    --infile, -i FILE   Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --outfile, -o FILE  Write target text to FILE.
    --src, -s LANG      Language code of source text.
    --targ, -t LANG     Language code of the target text.
"""

# Provided API
HTTP_REQUEST = """curl --silent --location --request POST \
'https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e&' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'User-Agent: AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1' \
--data-urlencode 'sl={sl}' \
--data-urlencode 'tl={tl}' \
--data-urlencode 'q={q}'"""

# Process command line arguments and request translation from Google. Exits
# with 0 on success and 1 otherwise.
def main() :
    ifile = ''
    ofile = ''
    targ_lang = ''
    src_lang = ''
    text = ''
    # parse args
    try :
        opts, args = getopt.getopt( sys.argv[ 1 : ], 'hi:lo:s:t:',
                                    [ 'help', 'infile=', 'list', 'outfile=',
                                      'src=', 'targ=' ] )
    except getopt.GetoptError as e :
        print( e + '\n' + help_msg )
        sys.exit( 1 )

    for o, a in opts :
        if o in ("-h", "--help") :
            # print help and exit
            print( help_msg )
            sys.exit( 0 )
        if o in ("-l", "--list") :
            # List languages and exit
            c = 0
            for k, v in LANGUAGES.items():
                s = ''
                if c % 2 == 0 and c > 0:
                    s += '\n'
                else:
                    s += '\t'
                s += '%-5s : %-21s' % (k, v)
                print(s, end='')
                c += 1
            print('\n')
            sys.exit(0)
        elif o in ("-i", "--infile") :
            # make sure file is readable
            if not os.access( a, os.R_OK ) :
                sys.stderr.write( 'Unable to read from file: ' + a + '\n' + help_msg )
                sys.exit( 1 )
            ifile = a
        elif o in ("-o", "--outfile") :
            ofile = a
        elif o in ("-t", "--targ") :
            # verify valid language
            if a not in LANGUAGES :
                sys.stderr.write( "Unsupported language code.\n" + help_msg )
                sys.exit( 1 )
            targ_lang = a
        elif o in ("-s", "--src") :
            # verify language
            if a not in LANGUAGES :
                sys.stderr.write( "Unsupported language code.\n" + help_msg )
                sys.exit( 1 )
            src_lang = a

    # make sure we have needed options
    if not targ_lang or not src_lang :
        sys.stderr.write( "Argument error: required argument missing.\n" + help_msg )
        sys.exit( 1 )

    # get text
    if ifile :
        try:
            with open( ifile, 'r' ) as f :
                text = ' '.join( f.readlines() )
        except:
            sys.stderr.write('Unable to read from: ' + ifile + '\n' + help_msg)
            sys.exit(1)
    else :
        text = ' '.join( args )

    # Get the Response and parse the results
    try:
        stream = os.popen(
                HTTP_REQUEST.format( sl=src_lang, tl=targ_lang, q=text ) )
        obj = json.loads( stream.read() )
        output = ' '.join( s[ 'trans' ].strip() for s in obj[ 'sentences' ] )
    except:
        sys.stderr.write('Unable to process HTTP request\n' + help_msg)
        sys.exit(1)

    # write to file if given or standard output
    if ofile :
        try:
            with open( ofile, 'w' ) as f :
                f.write( output )
        except :
            sys.stderr.write('Unable to write to ' + ofile + '\n' + help_msg)
            sys.exit(1)
    else :
        print( output )
    sys.exit( 0 )


if __name__ == '__main__' :
    main()
