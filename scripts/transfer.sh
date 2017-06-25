#!/bin/sh

set -e

curl \
    -H 'Max-Days: 1' \
    --upload-file "$1" \
    --progress-bar \
    'https://transfer.sh/'

# The response does not end with '\n'.
echo
