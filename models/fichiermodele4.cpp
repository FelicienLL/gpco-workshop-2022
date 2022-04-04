$PARAM @annotated
TVCL   :  1 : Clearance (volume/time)
TVV    : 20 : Central volume (volume)
KA   :  1 : Absorption rate constant (1/time)

ETA1 : 0 : individual CL
ETA2 : 0 : individual V

$CMT  @annotated
EV   : Extravascular compartment
CENT : Central compartment

$OMEGA
0.2
0.2

$SIGMA
0.05
0

$MAIN
double CL = TVCL * exp(ETA(1) + ETA1) ;
double V = TVV * exp(ETA(2) + ETA2) ;

$TABLE
double DV = CENT/V *(1 + EPS(1)) + EPS(2);

$PKMODEL ncmt = 1, depot = TRUE

$CAPTURE @annotated
DV : Plasma concentration (mass/volume)
CL : Clearance