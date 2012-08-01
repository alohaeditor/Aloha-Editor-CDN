#!/bin/bash

# Generic error check and abort method
function handleError() {
  if [ "$1" != "0" ]; then
     echo -e "\n\nERROR: $2"
     echo -e "Aborting with errorcode $1 \n\n"
     exit 10
  fi
}

cd target/cdn
handleError $? "Could not switch to cdn directory"

for dir in `ls` ; do

  echo -e "\n * Handling $dir" 
  echo "Cleanup"
    rm -rf $dir/api
    #handleError $? "Could not remove api."
    rm -rf $dir/doc
    #handleError $? "Could not remove doc."
  echo "Done."

  echo "Moving aloha dir"
    mv $dir/aloha/* $dir 
    #handleError $? "Could not move aloha files."
    rm -rf $dir/aloha
    #handleError $? "Could not remove empty aloha directory."
  echo "Done."
  
  echo "Removing demo"
    rm -rf $dir/demo
  echo "Done"
  
  echo "Removing tests"
    rm -rf $dir/test
  echo "Done"
done


# remove old index.html file
rm -f index.html
TPLDATA="<ul>"
  for dir in `ls` ; do
    if [ $dir != 'cdn-template.html' ]
    then
      TPLDATA="$TPLDATA<li><strong>$dir<\/strong>: <a href=\"\/$dir\/lib\/aloha.js\">aloha.js<\/a> \&middot; <a href=\"\/$dir\/css\/aloha.css\">aloha.css<\/a><\/li>"
    fi
  done
TPLDATA="$TPLDATA<\/ul>"

sed -e "s/<release-template>/$TPLDATA/g" ../../cdn-template.html > index.html
