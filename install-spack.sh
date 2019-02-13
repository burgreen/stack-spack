#!/bin/bash

#set -x 
set -e 

#--------------------------------------------
# purpose: install spack and basic setup
#
# author: greg.burgreen@msstate.edu
#         Mississippi State Univ
#         version 2019.02.11
#--------------------------------------------

if [ -z "$1" ]; then 
  echo usage: $0 \<spack_dir\>
  echo where \<spack_dir\> is the preferred name of your spack repo
  echo 
  echo For example, $0 ../stack-2019.02.11
  exit
fi

current=$(pwd)

spack_archive=spack-2019.02.12-f65a115.zip

pkg_libelf=sources-thirdparty-libelf.tar
scripts=scripts.tar

#--------------------------------------------
# 1. prelims
#--------------------------------------------

if [ -d $1 ]; then
   echo Directory $1 already exists.
   exit
fi

#source ./spack-setup-1-names-proteus.sh

mkdir -p $1

cp $current/README.md $1/0-README.md

cat >> $1/0-README.md << EOF

spack_archive = $spack_archive
EOF

#--------------------------------------------
# 2. write file: 3-names.sh
#--------------------------------------------

#cat > _names << EOF
##!/bin/bash
#
#EOF
#
#chmod +x _names
#
#mv _names $1/3-names.sh

#--------------------------------------------
# 3. unarchive spack_archive
#--------------------------------------------

echo Installing spack source: $spack_archive

#tar xfz $spack_archive.tar.gz
#mv $spack_archive/* $1
#mv $spack_archive/.[a-z]* $1
#rmdir $spack_archive

unzip -o $spack_archive
mv spack-develop/* $1
mv spack-develop/.[a-z]* $1
rmdir spack-develop

cd $1

#--------------------------------------------
# 4. unarchive tarballs
#--------------------------------------------

echo Installing other tarballs

tar xf $current/$pkg_libelf
tar xf $current/$scripts

chmod +x scripts/compiler.sh

#--------------------------------------------
# 5. write file: 1-setup-spack.sh
#--------------------------------------------

cat > 1-setup-spack.sh << EOF
#!/bin/bash

export SPACK_ROOT=$(pwd)

source \$SPACK_ROOT/share/spack/setup-env.sh
EOF

source ./1-setup-spack.sh

#--------------------------------------------
# 6. write file: mirrors.yaml
#--------------------------------------------

cat > $SPACK_ROOT/etc/spack/mirrors.yaml << EOF
mirrors:
  local_filesystem: file://$SPACK_ROOT/thirdparty
EOF

#--------------------------------------------
# 6. write instructions
#--------------------------------------------

echo ----------------------------------------
echo $spack_archive has been installed.
echo
echo Next steps:
echo 1. Change directory to ./$1
echo 2. Follow instructions in 0-README.txt

set +e
#set +x 
