#!/bin/bash
# ansible-vault-git-diff -- show what changed in a vaulted file at a specific commit
commit="$1"
file="$2"

if [ -z "$2" ]; then
  echo "Usage: $0 <commit> <file>"
  exit 1
fi

contents_of() {
  ansible-vault --vault-password-file=.vault_pass.txt view <( git show "$1":"$2" )
}

diff -u <( contents_of "${commit}^" "${file}" ) <( contents_of "${commit}" "${file}" )

