#!/bin/bash

mkdir dhdl

for d in lambda.*/; do
    d1=$(basename $d)
    lam="${d1##*.}"
    cd $d
    cd PROD

    cp dhdl.xvg  ../../dhdl/dhdl.lam${lam}.xvg
    cd ../../
done