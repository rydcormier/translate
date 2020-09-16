# translate
translate is a simple, easy-to-use command line interface for the Google
Translation API. Both a bash and python script are provided.


Usage  
=====

usage:  translate.(sh | py) [options] -s|--src <LANG> -t|--targ LANG [TEXT]

Options:

    --help, -h          Print this help message.
    --input, -i FILE    Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --output, -o FILE   Write target text to FILE.
    --source, -s LANG   Language code of source text.
    --target, -t LANG   Language code of the target text.


Options
=======

The target language for the given text (-t | --target) is required. The source language (-s | --source) is optional; the translator will try to determine the language of the source if none is given. The source text is read from
standard input unless a file is passed to the (-i | --input ) parameter.
The translated target text is written to standard output, unless another
output is assigned using the (-o | --output) flag.


Exit Status
===========

Exits with 0 on success and 1 otherwise.


Example
=======

    translate.(sh | py) -i source.txt -o target.txt -s en -t fr

This call translates the english text in source.txt to french and writes
the result to target.txt.

    translate.(sh | py) -i source.txt -o target.txt -t fr

This is an equivalent call, letting the translator determine the source
language.



License
=======

All work is released under the MIT license. See [`LICENSE`](../LICENSE.md) for details.
