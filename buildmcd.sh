#!/bin/sh

cd _mcd
cp ../map256/GHZ.kos ./disc/M256GHZ.KOS
cp "../map256/MZ (JP1).kos" ./disc/M256MZ.KOS
cp ../map256/SYZ.kos ./disc/M256SYZ.KOS
cp ../map256/LZ.kos ./disc/M256LZ.KOS
cp ../map256/SLZ.kos ./disc/M256SLZ.KOS
cp "../map256/SBZ (JP1).kos" ./disc/M256SBZ.KOS
cp "../artunc/Sonic.bin" ./disc/ARTSONIC.BIN
make clean && make
rm -f ./build/sonic.cue
#rm -f ./build/*.wav
cp sonic.cue ./build/sonic.cue
#cp ./music/*.wav ./build/
cd ../