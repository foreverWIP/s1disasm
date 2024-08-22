#!/bin/sh

cd _mcd
make clean && make
rm -f ./build/sonic.cue
#rm -f ./build/*.wav
cp sonic.cue ./build/sonic.cue
#cp ./music/*.wav ./build/
cd ../