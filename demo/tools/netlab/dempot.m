function e = dempot(x, mix)
%DEMPOT	Computes the negative log likelihood for a mixture settingl.
%
%	Description
%	This function computes the negative log of the unconditional data
%	density P(X) for a Gaussian mixture settingl.  The data structure MIX
%	defines the mixture settingl, while the matrix X contains the data
%	vectors.
%
%	See also
%	DEMGPOT, DEMHMC1, DEMMET1
%

%	Copyright (c) Ian T Nabney (1996-2001)

% Computes the potential (negative log likelihood)
e = -log(gmmprob(mix, x));