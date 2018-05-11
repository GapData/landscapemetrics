// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// ccl_borders
arma::mat ccl_borders(const arma::mat& m);
RcppExport SEXP _landscapemetrics_ccl_borders(SEXP mSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type m(mSEXP);
    rcpp_result_gen = Rcpp::wrap(ccl_borders(m));
    return rcpp_result_gen;
END_RCPP
}
// ccl_labels
Rcpp::List ccl_labels(const arma::mat& m);
RcppExport SEXP _landscapemetrics_ccl_labels(SEXP mSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type m(mSEXP);
    rcpp_result_gen = Rcpp::wrap(ccl_labels(m));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_landscapemetrics_ccl_borders", (DL_FUNC) &_landscapemetrics_ccl_borders, 1},
    {"_landscapemetrics_ccl_labels", (DL_FUNC) &_landscapemetrics_ccl_labels, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_landscapemetrics(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}