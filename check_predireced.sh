#!/bin/bash
awk -F'\t' '{if ($1 == $2) {print "ok"} else {print "ng"}}' | sort | uniq -c
