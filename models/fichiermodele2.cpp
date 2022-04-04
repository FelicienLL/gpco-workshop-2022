$PARAM @annotated
TVCL   :  1 : Clearance (volume/time)
TVV    : 20 : Central volume (volume)
KA   :  1 : Absorption rate constant (1/time)

$CMT  @annotated
EV   : Extravascular compartment
CENT : Central compartment

$OMEGA
0.2
0.2

$MAIN
double CL = TVCL * exp(ETA(1)) ;
double V = TVV * exp(ETA(2)) ;

$TABLE
double CP = CENT/V ;

$PKMODEL ncmt = 1, depot = TRUE

$CAPTURE @annotated
CP : Plasma concentration (mass/volume)
