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
    handleError $? "Could not remove api."
    rm -rf $dir/doc
    handleError $? "Could not remove doc."
  echo "Done."

  echo "Moving aloha dir"
    mv $dir/aloha/* $dir 
    handleError $? "Could not move aloha files."
    rm -rf $dir/aloha
    handleError $? "Could not remove empty aloha directory."
  echo "Done."
  
  echo "Removing demo"
    rm -rf $dir/demo
  echo "Done"
  
  echo "Removing tests"
    rm -rf $dir/test
  echo "Done"
done

