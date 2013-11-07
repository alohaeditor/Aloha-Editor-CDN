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

echo "Syncing $TMPDIR to s3"
  cd $TMPDIR
  aws s3 sync . s3://alohaeditor --acl public-read --delete --exclude *cdnlogs/*
  handleError $? "Error while syncing to s3"
  #TODO sync current / latest with nocache headers
echo "Done."