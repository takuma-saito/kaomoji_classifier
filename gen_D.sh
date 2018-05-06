#!/bin/bash -xe
seq 0 10 | xargs -I{} ./analyze_weights.sh {} 3
