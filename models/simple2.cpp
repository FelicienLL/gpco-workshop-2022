$PARAM @annotated
TVCL : 0.3 : Clearance (L/h)
TVV  : 20  : Central volume (L)
KA   : 1   : Absorption rate constant (h-1)

$PARAM @annotated @covariates
BW : 60 : Median Body Weight

$CMT  @annotated
DEPOT: Extravascular compartment
CENT : Central compartment

$MAIN
double CL = TVCL * exp(ETA(1)) * pow((BW / 60), 0.75) ;
double V = TVV * exp(ETA(2)) ;

$OMEGA
0.3
0.2

$SIGMA
0.04
0

$TABLE
double CP = CENT/V * (1 + EPS(1)) + EPS(2);

$PKMODEL ncmt = 1, depot = TRUE

$CAPTURE @annotated
CP : Plasma concentration
