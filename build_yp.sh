#!/bin/bash

rm -rf ./bin/yp.*xcframework && \
./scripts/generate_xcframework.sh yp debug 4.0 && \
cp -rf ./bin/yp.debug.xcframework /Users/erdembadluev/Documents/Projects/garage_game/ios/plugins/yp/ && \
cp -f ./plugins/yp/yp.gdip /Users/erdembadluev/Documents/Projects/garage_game/ios/plugins/yp/ && \
cp -rf ./bin/yp.debug.xcframework /Users/erdembadluev/Documents/Projects/garage_exported/Garage/dylibs/ios/plugins/yp/