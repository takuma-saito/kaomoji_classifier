#!/bin/bash -xe
cat training_data/data_set_0/cross_validation_data.txt | ruby predicted.rb training_data/data_set_0 |
    gsort --random-source=<(openssl enc -aes-256-ctr -pass pass:"12345678" -nosalt  </dev/zero) -R | head -n 20
