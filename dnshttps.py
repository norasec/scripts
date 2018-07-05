#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

import sys
from dns_over_https import SecureDNS


# after tunneling in a host
# set up a proxy in cygwin or linux terminal
# add to path or env, export http(s)_proxy, both
req = SecureDNS()
print req.gethostbyname(str(sys.argv[1]))
