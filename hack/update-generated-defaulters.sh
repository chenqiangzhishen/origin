#!/bin/bash
source "$(dirname "${BASH_SOURCE}")/lib/init.sh"

os::build::setup_env

os::util::ensure::built_binary_exists 'gendefaults'

PREFIX=github.com/openshift/origin

INPUT_DIRS=$(
  find . -not  \( \( -wholename '*/vendor/*' \) -prune \) -name '*.go' | \
	xargs grep --color=never -l '+k8s:defaulter-gen=' | \
	xargs -n1 dirname | \
	sed "s,^\.,${PREFIX}," | \
	sort -u | \
	paste -sd,
)

EXTRA_PEER_DIRS=$(
  grep -rl SetDefaults_ vendor/k8s.io/kubernetes/pkg | \
  xargs -n1 dirname | \
  sort -u | \
  sed 's,^vendor/,,' | \
  paste -sd,
)

gendefaults \
	--logtostderr \
	--output-base="${GOPATH}/src" \
	--input-dirs ${INPUT_DIRS[@]} \
  --extra-peer-dirs ${EXTRA_PEER_DIRS[@]} \
	"$@"
