#!/bin/bash -f

# Check the output of mount for sshfs mounted directories, and do The
# Right Thing
function doMount () {
  mount | awk -v cwd=$CWD -v cmd="${CMD}" -v cdcmd="$CDCMD" '
  /.*@.*:.* on / { 
    if ( cwd ~ $3 ) {
      sep=index($1, ":")
      host=substr($1,0,sep-1)
      newpath=substr($1,sep+1,255)
  
      gsub($3, newpath, cdcmd)
  
      cmd="ssh " host " " cdcmd
    }
  }
  END { 
    print cmd
  }' | bash
}

# Check the contents of 
function doMap() {
  awk -v cwd=$CWD -v cmd="${CMD}" -v cdcmd="$CDCMD" '
  /^.* .*:.*/ {
    if ( cwd ~ $1 ) {
      sep=index($2, ":")
      host=substr($2,0,sep-1)
      newpath=substr($2,sep+1,255)
     
      gsub($1, newpath, cdcmd)
      cmd="ssh " host " " cdcmd
    }
  }
  END {
    print cmd
  }' $MAP_FILE | bash
}

function usage () {
    echo "Usage: `basename $0` [-h] [-m] [-f mapfile] cmd ..."
}

while getopts ":hmf:" opt; do
  case $opt in
    m) 
       FORCE_MOUNT=1
       ;;
    f)
       MAP_FILE=${OPTARG}
       ;;
    h)
       usage
       exit 0
       ;;
    \?)
       usage
       exit 1
       ;;
  esac
  shift $((OPTIND-1))
done      

CWD=$(pwd -P)
CMD="$@"
CDCMD="'cd $CWD; $@'"

if [[ -z $MAP_FILE ]]; then
  MAP_FILE="$HOME/.sharemap"
fi

if [[ ! -z $FORCE_MOUNT || ! -e $MAP_FILE ]]; then
    doMount
else
    doMap
fi
