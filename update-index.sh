#!/bin/bash
set -e
git checkout gh-pages
REPOS="cert-manager-webhook-dnsimple paperboy papergirl"
mkdir .cr-release-packages

for repo in $REPOS ; do
  mkdir $repo
  cr index -i ./$repo -o neoskop -r $repo -c https://neoskop.github.io/$repo
done

yq m `for repo in $REPOS ; do echo $repo/index.yaml ; done` | yq w - 'generated' `date -Ins` > index.yaml
rm -rf .cr-release-packages
for repo in $REPOS ; do rm -rf $repo ; done
git add index.yaml
git commit -m "chore: Update chart index."
git push
git checkout master