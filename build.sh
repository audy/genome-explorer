#!/bin/bash

set -euo pipefail

image="audy/genome-explorer"

docker build --tag ${image} .
