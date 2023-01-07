#!/usr/bin/env python
# coding: utf-8


# fichier python récupéré dans le dossier PPE


import thulac
import errno
import fileinput


seg = thulac.thulac(seg_only=True)
try:
    for line in fileinput.input():
        print(seg.cut(line, text=True))
except IOError as e:
    if e.errno != errno.EPIPE:
        raise
