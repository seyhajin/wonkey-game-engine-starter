#!/usr/bin/env bash

if [ ! -f "scripts/install.sh" ]; then
    echo "Invoke this script from the root directory of the checkout."
    echo ""
    echo "FAILED!"
    exit 1
fi

./setup.sh
./sync.sh
./build.sh
./copy.sh