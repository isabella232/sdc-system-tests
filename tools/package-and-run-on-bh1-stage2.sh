#!/bin/bash
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2014, Joyent, Inc.
#

#
# Quick script for development to package up the current state, scp to
# bh1-stage2 and run it there.
#

set -e
set -x

NODE=root@10.2.109.20
TOP=$(cd $(dirname $0)/../; pwd)

cd $TOP
ssh $NODE 'touch /var/tmp/sdc-system-tests-foo'
ssh $NODE 'rm -rf /var/tmp/sdc-system-tests*'
rm -f sdc-system-tests-*.tgz
make release
scp sdc-sys*.tgz $NODE:/var/tmp
ssh $NODE 'cd /var/tmp && gtar xf sdc-system-tests-* && TRACE=1 bash /var/tmp/sdc-system-tests-*/runtests'
