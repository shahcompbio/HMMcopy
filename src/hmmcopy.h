#include <string.h>
#include <math.h>
#include <R.h>
#include <Rdefines.h>
#include <Rinternals.h>

/* Functions called by R code */

SEXP forward_backward(SEXP piZ, SEXP A, SEXP py);
SEXP viterbi(SEXP piZ, SEXP A, SEXP py);
