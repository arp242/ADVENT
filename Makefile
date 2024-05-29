.PHONY: all

STATIC=-static

all:
	gfortran -o advent -std=legacy ${STATIC} advent.for
	gfortran -o wiz    -std=legacy ${STATIC} wiz.for
