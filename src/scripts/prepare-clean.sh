#!/bin/bash
#
# Cleans the old legacy artifacts and creates nice folder 
# structure for the cdn upload

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

cd $TMPDIR
handleError $? "Could not switch to cdn directory"

for dirname in `ls $TMPDIR` ; do

  DIR=$TMPDIR/$dirname
  echo -e "\n * Handling $dirname"
  
  echo "Extraction"
    cd $DIR
    ls | grep -q cdn
    ISCDN=$?
    if [ "$ISCDN" == "0" ] ; then
      echo "Folder contains cdn version.."
      unzip -q *cdn.zip
    else
      echo "Folder does not contain cdn version.."
      unzip -q *.zip
    fi
    rm *.zip
  echo -e "Done.\n"

  echo "Cleanup"
    rm -rf $DIR/api
    #handleError $? "Could not remove api."
    rm -rf $DIR/doc
    #handleError $? "Could not remove doc."
  echo -e "Done.\n"
  
  if [ "$ISCDN" == "1" ] ; then
    echo "Moving aloha dir"
      mv $DIR/aloha/* $DIR 
      handleError $? "Could not move aloha files."
      rm -rf $DIR/aloha
      handleError $? "Could not remove empty aloha directory."
    echo -e "Done.\n"
    echo "Removing demo"
      rm -rf $DIR/demo &> /dev/null
    echo -e "Done.\n"
    echo "Removing tests"
      rm -rf $DIR/test &> /dev/null
    echo -e "Done.\n"
  fi
done

cd $TMPDIR

HEADER=$( cat <<EOF
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en"> 
<head>
	<title>Aloha Editor - CDN</title>
</head>
<body>
EOF
)
echo $HEADER >> index.html
echo '<ul>' >> index.html
  for dirname in `ls $TMPDIR` ; do
    echo "<li>$dirname</li>" >> index.html
  done
echo '</ul>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
