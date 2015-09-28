#!/bin/sh

DIR=`dirname $(readlink -f $0)`
pushd $DIR/../tests
oscript finder.os
popd