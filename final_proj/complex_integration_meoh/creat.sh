#!/bin/bash

for i in {0..29}
do
    mkdir "lambda.$(printf "%02d" $i)"
done