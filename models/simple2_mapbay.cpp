$PARAM @annotated
TVCL : 0.3 : Clearance (L/h)
TVV  : 20  : Central volume (L)
KA   : 1   : Absorption rate constant (h-1)
ETA1 : 0 : Eta Clearance
ETA2 : 0 : Eta Volume

$PARAM @annotated @covariates
BW : 60 : Median Body Weight

$CMT  @annotated
DEPOT: Extravascular compartment
CENT : Central compartment

$MAIN
double CL = TVCL * exp(ETA(1) + ETA1) * pow((BW / 60), 0.75) ;
double V = TVV * exp(ETA(2) + ETA2) ;

$OMEGA
0.3
0.2

$SIGMA
0.04
0

$TABLE
double DV = CENT/V * (1 + EPS(1)) + EPS(2);

$PKMODEL ncmt = 1, depot = TRUE

$CAPTURE @annotated
DV : Plasma concentration
CL : Clearance
V : volume
