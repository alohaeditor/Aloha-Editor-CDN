#!/bin/bash

SCRIPT="`readlink -f $0`" 
BASEDIR="`dirname "$SCRIPT"`"
TMPDIR=$BASEDIR/../../target/downloads

# Generic error check and abort method
function handleError() {
  if [ "$1" != "0" ]; then
    echo -e "\n\nERROR: $2"
    echo -e "Aborting with errorcode $1 \n\n"
    exit 10
  fi
}

mkdir -p $TMPDIR
handleError $? "Could not create tmpdir"
cd $TMPDIR
handleError $? "Could not switch to cdn directory"

wget --exclude-directories='*/*/*/*/*SNAPSHOT*,*/*/*/*/*beta*,*/*/*/*/*commercial*' -R *source* -r -l5 --no-parent -nc -A zip https://maven.gentics.com/maven2/org/alohaeditor/alohaeditor/
handleError $? "Error while downloading artifacts"
mv maven.gentics.com/maven2/org/alohaeditor/alohaeditor/* .
handleError $? "Error while moving artifacts"
rm -rf maven.gentics.com
handleError $? "Error while removing bogus folder"