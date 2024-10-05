#!/bin/sh

rm -rf ./_mcd/disc/*
cp ./build/mmd/*.bin ./_mcd/disc/
cp "./artnem/8x8 - GHZ1.nem" ./_mcd/disc/ARTGHZ1.NEM
cp "./artnem/8x8 - GHZ2.nem" ./_mcd/disc/ARTGHZ2.NEM
cp "./artnem/8x8 - MZ.nem" ./_mcd/disc/ARTMZ.NEM
cp "./artnem/8x8 - SYZ.nem" ./_mcd/disc/ARTSYZ.NEM
cp "./artnem/8x8 - LZ.nem" ./_mcd/disc/ARTLZ.NEM
cp "./artnem/8x8 - SLZ.nem" ./_mcd/disc/ARTSLZ.NEM
cp "./artnem/8x8 - SBZ.nem" ./_mcd/disc/ARTSBZ.NEM
cp ./map16/GHZ.unc ./_mcd/disc/M16GHZ.BIN
cp ./map16/MZ.unc ./_mcd/disc/M16MZ.BIN
cp ./map16/SYZ.unc ./_mcd/disc/M16SYZ.BIN
cp ./map16/LZ.unc ./_mcd/disc/M16LZ.BIN
cp ./map16/SLZ.unc ./_mcd/disc/M16SLZ.BIN
cp ./map16/SBZ.unc ./_mcd/disc/M16SBZ.BIN
cp ./map256/GHZ.kos ./_mcd/disc/M256GHZ.KOS
cp "./map256/MZ (JP1).kos" ./_mcd/disc/M256MZ.KOS
cp ./map256/SYZ.kos ./_mcd/disc/M256SYZ.KOS
cp ./map256/LZ.kos ./_mcd/disc/M256LZ.KOS
cp ./map256/SLZ.kos ./_mcd/disc/M256SLZ.KOS
cp "./map256/SBZ (JP1).kos" ./_mcd/disc/M256SBZ.KOS
cp "./artunc/Sonic.bin" ./_mcd/disc/ARTSONIC.BIN
cat ./sound/mcd/kick.pcm ./sound/mcd/snare.pcm ./sound/mcd/timpani.pcm > ./_mcd/disc/DRUMS.PCM
cp ./sound/mcd/splshsnd.pcm ./_mcd/disc/SPLSHSND.PCM
cd _mcd
make clean && make disc
mv ./disc.iso ./build/sonic.iso
rm -f ./build/sonic.cue
#rm -f ./build/*.wav
cp sonic.cue ./build/sonic.cue
#cp ./music/*.wav ./build/
cd ../