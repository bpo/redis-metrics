#! /bin/bash

usage()
{
  cat <<EOF

  A simple driver for testing local lua scripts with Redis.

usage: $0 script numkeys [key ...] [arg ...]

  script is the path of a file containing a lua script
  numkeys is the number of keys modified by that script

  Each key is accessible in the lua script using the KEYS global variable.
  Each arg is accessible in the lua script using the ARGV global variable.

example: $ $0 hello.lua 0

  Read more: http://redis.io/commands/eval
EOF

  exit 1
}

if (( $# <= 1 )) ; then
  echo "Error: need at least two arguments."

  usage
elif [ "$1" = "-h" ] ; then
  usage
fi

script=$1
shift

redis-cli EVAL "$(cat $script)" $@
