# translate
translate is a simple, easy-to-use command line interface for the Google
Translation API.


Usage  
=====

usage:  translate [options] -s|--src <LANG> -t|--targ <LANG> [TEXT]

Options:

    --help, -h          Print this help message.
    --infile, -i FILE   Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --outfile, -o FILE  Write target text to FILE.
    --src, -s LANG      Language code of source text.
    --targ, -t LANG     Language code of the target text.


Options
=======

The language of the source text (-s | --src) and the language of the target
text (-t | --targ) are required. If no input file (-i | --infile) is given,
the source text is assumed to be everything after the options from standard
input. If no output file (-o | --ofile) is given, the target text is written
to standard output.


Exit Status
===========

Exits with 0 on success and 1 otherwise.


Example
=======

    translate -i source.txt -o target.txt -s en -t fr

This call translates the english text in source.txt to french and writes
the result to target.txt.

License
=======

All work is released under the MIT license. See [`LICENSE`](../LICENSE.md) for details.
