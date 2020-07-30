#!/bin/bash
set -e
git checkout gh-pages
REPOS="cert-manager-webhook-dnsimple paperboy papergirl mgnl-on-k8s"
mkdir .cr-release-packages

for repo in $REPOS ; do
  mkdir $repo
  wget -O ./$repo/index.yaml https://raw.githubusercontent.com/neoskop/$repo/gh-pages/index.yaml
done

yq m `for repo in $REPOS ; do echo $repo/index.yaml ; done` | yq w - 'generated' `date -Ins | tr , .` > index.yaml
rm -rf .cr-release-packages
for repo in $REPOS ; do rm -rf $repo ; done
git add index.yaml
git commit -m "chore: Update chart index."
git push
git checkout master