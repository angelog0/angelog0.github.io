#!/bin/bash
#
## Usage
##
##    ./get_and_install-emacs-23.1.release.sh
##

WGET="wget -N"
EMACS_DIR="http://www.webalice.it/angelo.graziosi/cygwin/emacs"
PKGS_DIR="${EMACS_DIR}/release"

PKG1="pkg.1-emacs-23.1.release.tar.lzma"
PKG2="pkg.2-emacs-23.1.release.tar.lzma"
PKG3="pkg.3-emacs-23.1.release.tar.lzma"
PKG4="pkg.4-emacs-23.1.release.tar.lzma"

echo "***************************"
echo "Downloading the packages..."
echo "***************************"
echo ""

${WGET} ${PKGS_DIR}/${PKG1}
${WGET} ${PKGS_DIR}/${PKG2}
${WGET} ${PKGS_DIR}/${PKG3}
${WGET} ${PKGS_DIR}/${PKG4}

TAR="tar --lzma -xf"
INST_DIR="/"

echo ""
echo ""
echo -n "Installing the packages..."

${TAR} ${PKG1} -C ${INST_DIR}
${TAR} ${PKG2} -C ${INST_DIR}
${TAR} ${PKG3} -C ${INST_DIR}
${TAR} ${PKG4} -C ${INST_DIR}

cd /usr/local/bin

ln -sf /usr/local/emacs/bin/emacs.exe emacs23
echo "done."
