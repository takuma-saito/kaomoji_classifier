#!/bin/bash -xe
cat training_data/data_set_0/cross_validation_data.txt | ruby predicted.rb training_data/data_set_0 | sort -R | head -n 20
