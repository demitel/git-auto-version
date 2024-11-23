#!/bin/sh

showVer() {
    echo "* Version:" `git auto-version`
}

TEST=0
mktest() {
    echo "* test$TEST"
    touch test$TEST.txt
    git add .
    if [ "$1" != "" ]; then
        git commit -m "$1"
    else
        git commit -m "test$TEST"
    fi
    showVer
    TEST=$(($TEST+1))
}

rm -rf test
mkdir -p test
cd test
git auto-version init
showVer
echo "==============="
mktest v0.0
mktest v0.1-0.5
echo "* Bump version"
git auto-version mktag 0.5
showVer
echo "* Test dirty"
touch -d "5 minutes" dirty
showVer
rm -f dirty
mktest v0.6
echo "==============="
git auto-version fix
showVer
mktest v0.6.1
mktest v0.6.2
git checkout -
echo "==============="
git auto-version develop 1.0
showVer
mktest v1.0~1
echo 
mktest v1.0~2
git checkout -
echo "==============="
git switch -c develop
showVer
mktest v1.1~1
echo "* Create manual tag"
git auto-version mktag "1.1-dev"
showVer
mktest v1.1~2
mktest v1.1~3
echo "==============="
git auto-version feature feature
showVer
mktest 1.1~3+cA.feature
mktest 1.1~3+cB.feature
git checkout -
echo "==============="
git merge --no-ff develop-feature
git checkout master
echo "==============="
git auto-version rc from develop-1.0
showVer
mktest 1.0.0~2
git auto-version rc from develop
showVer
mktest 1.1.0~2
git checkout -
echo "==============="
git auto-version release from rc-1.1
showVer
mktest v1.2
mktest v1.3
echo "==============="
git log --graph --oneline --all
