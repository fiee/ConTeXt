#!/bin/bash
MODNAME=lilypond
BASEDIR=~/workspace/context/t-${MODNAME}/
SUBDIR=/context/third/${MODNAME}/
cd ${BASEDIR}tex${SUBDIR}
context t-${MODNAME} --mode=demo --result=demo
context --ctx=s-mod.ctx t-${MODNAME}
context --purge
mv *.pdf ${BASEDIR}/doc/${SUBDIR}
cd ${BASEDIR}
zip -u ../t-${MODNAME}-`date +"%Y-%m-%d"`.zip doc${SUBDIR}*.pdf
zip -u ../t-${MODNAME}-`date +"%Y-%m-%d"`.zip tex${SUBDIR}t-${MODNAME}.tex
