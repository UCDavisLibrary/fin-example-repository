#! /bin/bash

#####
# A simple script using the fin-cli to add data to Fedora
#####

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

## Create the collection (remove if exists)
fin collection delete -f example_1-pets
fin collection create example_1-pets index.ttl
# Add in public users.
fin collection acl user add example_1-pets PUBLIC r

fin cd /collection/example_1-pets
## Add a thumbnail
fin http put -@ thumbnail.png -P b thumbnail
fin http patch -@ /dev/stdin <<< 'prefix s: <http://schema.org/> insert {<> s:thumbnail <example_1-pets/thumbnail> } WHERE {}' -P h

fin collection relation add-container example_1-pets pets -T part

for file in *.jpg
do
  id=`basename $file .jpg`;
  fin collection resource add -t ImageObject -m $file.ttl example_1-pets ./$file pets/$id
done

fin collection relation add-properties example_1-pets http://schema.org/workExample http://schema.org/exampleOfWork ashley
