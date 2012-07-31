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
  for dir in `ls` ; do
    echo "<li>$dir</li>" >> index.html
  done
echo '</ul>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
