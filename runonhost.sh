#!/bin/bash -f

CWD=$(pwd -P)
CMD="$@"
CDCMD="\'cd $CWD; $@\'"

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
