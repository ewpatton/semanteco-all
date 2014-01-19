#!/bin/bash

BAR="-----------------------------------------------------------------------"
OWNER=${OWNER:-ewpatton}
GIT=${GIT:-`which git`}
if [ "$GIT" = "" ]; then
    echo "Could not find git on your PATH. Please add it to your path or "
    echo "specify its location with GIT=<path/to/git> $0"
    exit -1
fi

ALLPACKAGES="dataone-solr-search \
    semanteco-annotator \
    semanteco-archetypes \
    semanteco-common \
    semanteco-core \
    semanteco-darrin-facet \
    semanteco-facets \
    semanteco-geo-facet \
    semanteco-geopoly-facet \
    semanteco-parent \
    semanteco-query \
    semanteco-sample \
    semanteco-servlet \
    semanteco-test \
    SemantEco"

PACKAGES=${@:-$ALLPACKAGES}
for PACKAGE in $PACKAGES
do
    # attempt to check out writable copy from user's github account
    echo $BAR
    echo "                         $PACKAGE"
    echo $BAR
    if [ "$PACKAGE" = "SemantEco" ]; then
        TARGET="semanteco-webapp"
    else
        TARGET=$PACKAGE
    fi
    $GIT clone -b develop git@github.com:$OWNER/$PACKAGE.git $TARGET > /dev/null
    if [ $? -ne 0 ]; then
        # check out read-only copy from original repo
        echo "Unable to clone via SSH, falling back to HTTP."
        $GIT clone -b develop https://github.com/ewpatton/$PACKAGE.git $TARGET > /dev/null
    fi
    echo
done
