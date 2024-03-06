#!/bin/bash
set -e
git checkout gh-pages
REPOS="ixy cert-manager-webhook-dnsimple paperboy papergirl mgnl-on-k8s"

for repo in $REPOS ; do
  mkdir $repo
  wget -O ./$repo/index.yaml https://raw.githubusercontent.com/neoskop/$repo/gh-pages/index.yaml
done

REPOS_ARR=( $REPOS )
YQ_EXPR=$(for ((i=0; i<${#REPOS_ARR[@]}; i++)) ; do echo -n "select(fi == $i)" && [ "$i" -ne "$((${#REPOS_ARR[@]} - 1))" ] && echo -n  " * " ; done)
yq eval-all "$YQ_EXPR" `for repo in $REPOS ; do echo $repo/index.yaml ; done` | yq eval ".generated=\"`date -Ins | tr , .`\"" -i - > index.yaml
for repo in $REPOS ; do rm -rf $repo ; done
git add index.yaml
git commit -m "chore: Update chart index."
git push
git checkout master
