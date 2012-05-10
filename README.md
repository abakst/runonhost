runonhost
=========

Attempts to determine if a command is to be executed on a filesystem
that lives on a remote host. If so, runs the command on the remote
host via ssh.

This is done via two mechanisms. The user may specify a file (by
default $HOME/.sharemap) that maps directories on the local file
system to directories on the remote filesystem. The format of this
file is:

/path/on/local/fs/ host:/path/on/host/fs

The script may also check the output of the `mount' command to
discover any file systems mounted via sshfs.

Usage:
$ runonhost.sh [-h] [-m] [-f map_file] cmd

  -h             Display the above usage.
  
  -m             Force runonhost.sh to use the output of mount.
  
  -f map_file    Use map_file instead of the default ($HOME/.sharemap) to
                 read mappings between local and remote directories.

