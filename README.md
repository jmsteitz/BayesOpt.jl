# BayesOpt

[![Build Status](https://travis-ci.org/bicycle1885/BayesOpt.jl.svg?branch=master)](https://travis-ci.org/bicycle1885/BayesOpt.jl)

A Julia wrapper for the
[BayesOpt](http://rmcantin.bitbucket.org/html/index.html) library: an efficient
implementation of the Bayesian optimization for black-box optimization.

Martinez-Cantin, Ruben. "BayesOpt: a Bayesian optimization library for nonlinear optimization, experimental design and bandits." *The Journal of Machine Learning Research* 15.1 (2014): 3735-3739.
 
## Prerequisite

* CMake
* Boost

## Installation

`Pkg.clone("git@github.com:bicycle1885/BayesOpt.jl.git")` will automatically
download source code and build the library under the `deps/` directory.
