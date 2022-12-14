F90C = gfortran

solve: solve.f90
	${F90C} -g -lgfortran -o $@ $<

.PHONY: clean

clean:
	rm -f *.o solve
