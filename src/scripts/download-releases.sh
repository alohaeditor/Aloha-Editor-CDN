#!/bin/bash

SCRIPT="`readlink -f $0`" 
BASEDIR="`dirname "$SCRIPT"`"
TMPDIR=$BASEDIR/../../target/downloads
CACHEDIR=/var/tmp/aloha-downloads

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

if [ -e $CACHEDIR ] ; then 
  rsync -rav $CACHEDIR/* .
  handleError $? "Could not sync files from cachedir to $TMPDIR"
else 
  mkdir -p $CACHEDIR
fi 

wget -nv --exclude-directories='*/*/*/*/*SNAPSHOT*,*/*/*/*/*beta*,*/*/*/*/*commercial*' -R *source* -r -l5 --no-parent -nc -A zip https://maven.gentics.com/maven2/org/alohaeditor/alohaeditor/
handleError $? "Error while downloading artifacts"

# Update the cache
rsync -rav $TMPDIR/maven* $CACHEDIR
handleError $? "Could not update the cache dir"

mv maven.gentics.com/maven2/org/alohaeditor/alohaeditor/* .
handleError $? "Error while moving artifacts"
rm -rf maven.gentics.com
handleError $? "Error while removing bogus folder"