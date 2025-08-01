#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname $(realpath -s "$0"))


if [ ! -z "${VIRTUAL_ENV:+x}" ]; then
    cd "$VIRTUAL_ENV/bin"
else
    cd $SCRIPT_DIR
fi


if [ ! -z "${1:+x}" ]; then
    NEW_SHEBANG="#!$1"
else
    NEW_SHEBANG="#!$PWD/python3"
fi


if [ ! -z "${2:+x}" ]; then
    OLD_SHEBANG_REGEX='^#!'"$2"'$'
else
    OLD_SHEBANG_REGEX='^#!.*python[0-9.]*([ \t].*)?$'
fi


echo "Set shebang to \"$NEW_SHEBANG\" for files:"

find $PWD -mindepth 1 -maxdepth 1 -type f -print0 | while IFS= read -r -d '' F; do \
    head -1 $F | grep -q -E "$OLD_SHEBANG_REGEX" || continue
    echo "$F"
    sed -i -E '1s|.*|'"$NEW_SHEBANG"'|' $F
done

#find . -mindepth 1 -maxdepth 1 -type f -print -exec \
#    sed -i -E '1s|'"$OLD_SHEBANG_REGEX"'|'"$NEW_SHEBANG"'|' {} +

echo "Done"
