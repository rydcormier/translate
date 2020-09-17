#!/usr/bin/env bash
#
#   Command line text translation tool.
#
#   This script uses the Google Translation API and allows the user to
#   translate text from the command line.
#
#   Ryan Cormier <rydcormier@gmail.com>
#   8/15/20
#

HELP='usage:  translate.sh [options] (-t | --target) LANG [TEXT]

Options:

    --help, -h          Print this help message.
    --input, -i FILE    Read source text from FILE.
    --list, -l          List supported languages and corresponding codes.
    --output, -o FILE   Write target text to FILE.
    --source, -s LANG   Language or language code of source text. If not given,
                        the translator will try to determine the source language.
    --target, -t LANG   Language or Language code of the target text.'

LANGFILE='languages.txt'

# Use curl to make the HTTP request
if ! command -v curl &> /dev/null; then
    echo "Error: curl could not be found. Aborting."
    exit 1
fi


# get supported languages.  TODO: add filter for chinese
declare -a LANGUAGES
declare -a LANGCODES
let i=0
{
    while read LINE; do
        LANGUAGES[i]="${LINE%%[[:space:]]*}"
        LANGCODES[i]="${LINE##*[[:space:]]}"
        let i++
    done
}<languages.txt


# Given a language name, if it is valid, print the corresponding code to
# stdin. Given a valid code, print that. Otherwise, do nothing. Return 1
# if a match is found. Return 0 otherwise.
#
function get_code {
    local lang="$*"
    local NUM_LANGS="${#LANGUAGES[@]}"
    for ((i=0;i < NUM_LANGS;i++)); do
        if [ "${lang}" == "${LANGUAGES[i]}" ] || [ "${lang}" == "${LANGCODES[i]}" ]; then
            echo "${LANGCODES[i]}"
            return 1
        fi
    done
    return 0
}


# make all opts short
for arg in "$@"; do
    shift
    case "$arg" in
        "--help")   set -- "$@" "-h" ;;
        "--input")  set -- "$@" "-i" ;;
        "--list")   set -- "$@" "-l" ;;
        "--output") set -- "$@" "-o" ;;
        "--source") set -- "$@" "-s" ;;
        "--target") set -- "$@" "-t" ;;
        *)          set -- "$@" "$arg"
    esac
done

# parse options
OPTIND=1
while getopts "hi:lo:s:t:" opt; do
    case "$opt" in
        h)
            echo "$HELP"
            exit
            ;;
        i)
            if ! [ -r "${OPTARG}" ]; then
                >&2 echo "Error: Unable to read from ${OPTARG}."
                exit 1
            fi
            TEXT="$(cat ${OPTARG} | tr '\r\n' ' ')"
            ;;
        l)
            cat "${LANGFILE}"
            exit
            ;;
        o)
            if ! [ -w "${OPTARG}" ]; then
                >&2 echo "Error: Unable to write to ${OPTARG}."
                exit 1
            fi
            OUTPUT="${OPTARG}"
            ;;
        s)
            SRC="$(get_code "${OPTARG}")"
            if [ -z "${SRC}" ]; then
                >&2 echo "Error: ${OPTARG} is not a supported language."
                exit 1
            fi
            ;;
        t)
            TARGET="$(get_code "${OPTARG}")"
            if [ -z "${TARGET}" ]; then
                >&2 echo "Error: ${OPTARG} is not a supported language."
                exit 1
            fi
            ;;
        ?)
            echo "${HELP}"
            exit 1
    esac
done

shift "$((OPTIND -1))"

# target is required
if [ -z "${TARGET}" ]; then
    >&2 echo "Error: No target language given."
    exit 1
fi

# add data to HTTP request
DATA="--data-urlencode sl="${SRC:-auto}" --data-urlencode tl="${TARGET}" --data-urlencode q='"${TEXT}"'"


# use a temp file for the response
tmpfile="$(mktemp /tmp/tmp.XXXXX)"

# Get the response and only keeep the "trans" values
curl --silent --location --request POST 'https://translate.google.com/translate_a/single?client=at&dt=t&dt=ld&dt=qca&dt=rm&dt=bd&dj=1&hl=%25s&ie=UTF-8&oe=UTF-8&inputm=2&otf=2&iid=1dd3b944-fa62-4b55-b330-74909a99969e&' \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --header 'User-Agent: AndroidTranslate/5.3.0.RC02.130475354-53000263 5.1 phone TRANSLATE_OPM5_TEST_1' \
    --data-urlencode sl="${SRC:-auto}" \
    --data-urlencode tl="${TARGET}" \
    --data-urlencode q="${TEXT:-$*}" | grep -o '"trans":"[^"]*"' > "$tmpfile"

# make sure we got something
if ! [ -s "${tmpfile}" ]; then
    >&2 echo "Error: Unable to get HTTP response."
    rm "${tmpfile}"
    exit 1
fi

# extract and combine the translated sentences
RESULT=''
{ while read line; do
    trans="${line#*:\"}"
    trans="${trans%\"}"
    RESULT="${RESULT}${trans}"
done }<"${tmpfile}"

rm "${tmpfile}"

# TODO: add more decoding. For now just convert the apostrophes
if [ -n "${OUTPUT}" ]; then
    echo ${RESULT//u0027/\'} > "${OUTPUT}"
else
    echo ${RESULT//u0027/\'}
fi

exit
