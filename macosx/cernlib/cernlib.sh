##
## To be copied in /etc/profile.d
##

## General definitions...
GREP=`which grep 2> /dev/null`

export CERN=/usr/local/cernlib
export CERN_LEVEL=2006
export CERN_ROOT=${CERN}/${CERN_LEVEL}
export CERN_LIB=${CERN_ROOT}/lib
export CERN_INC=${CERN_ROOT}/include

## These are aux. vars
CERN_BIN=${CERN_ROOT}/bin
#CERN_MAN=${CERN_ROOT}/share/man

if test -n "${PATH}"; then
  # PATH is not empty

  # Check if path is already in PATH
  if ! echo ${PATH} | ${GREP} -q "${CERN_BIN}" ; then
    # Path is not already in PATH, append it to PATH
    export PATH="${PATH}:${CERN_BIN}"
  fi
else
  # PATH is empty
  export PATH="${CERN_BIN}"
fi

# if test -n "${MANPATH}"; then
#   # MANPATH is not empty

#   # Check if path is already in MANPATH
#   if ! /bin/echo ${MANPATH} | ${GREP} -q "${CERN_MAN}" ; then
#     # Path is not already in MANPATH, append it to MANPATH
#     export MANPATH="${MANPATH}:${CERN_MAN}"
#   fi
# else
#   # MANPATH is empty
#   export MANPATH="${CERN_MAN}"
# fi

unset CERN_BIN
#unset CERN_MAN
