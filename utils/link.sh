#!/bin/bash

cd "$(dirname "$0")/.."

[[ ! -d libs ]] && mkdir -p libs
[[ ! -L libs/LibStub ]] && ln -s ../LibStub libs/LibStub
[[ ! -L libs/CallbackHandler-1.0 ]] && ln -s ../CallbackHandler-1.0 libs/CallbackHandler-1.0
[[ ! -L libs/HereBeDragons ]] && ln -s ../HereBeDragons libs/HereBeDragons
[[ ! -L libs/LibBabble-SubZone-3.0 ]] && ln -s ../LibBabble-SubZone-3.0 libs/LibBabble-SubZone-3.0
