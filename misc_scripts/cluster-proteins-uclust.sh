#!/bin/bash

set -x
set -e

IDENTITY='0.2'
INPUT='proteins.fasta'

# sort by length
uclust \
  --sort $INPUT \
  --output sorted.fasta

# cluster
uclust \
  --input sorted.fasta \
  --uc clusters.$IDENTITY.uc \
  --id $IDENTITY
