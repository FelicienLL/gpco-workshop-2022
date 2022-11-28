$PARAM @annotated
TVKA : 4.12 : Typical Abs constant (h-1)
ALAG : 0.0545 : Lag time (h)
TVCLMALE : 22.1 : Typical CL value, male (L/h)
TVCLFEM : 17.7 : Typical CL value, female (L/h)
TVV2 : 58.6 : Typical Central volume (L)
TVV3 : 11.2 : Typical Periph volume (L)
Q: 2.53 : Inter compartmental CL

$PARAM @annotated
ETA1 : 0 : Eta KA
ETA2 : 0 : Eta CL
ETA3 : 0 : Eta VC
ETA4 : 0 : Eta VP

$PARAM @annotated @covariates
BW : 72.9 : Median Body Weight (kg)
SEX : 0 : Sexe (0 Homme, 1 Femme)

$CMT  @annotated
DEPOT: Extravascular compartment
CENT : Central compartment
PERIPH : Peripheral compartment

$MAIN
double KA = TVKA * exp(ETA(1) + ETA1) ;
double TVCL = TVCLMALE ;
if(SEX == 1)
TVCL = TVCLFEM ;
double CL = TVCL * exp(ETA(2)+ ETA2) ;
double V2 = TVV2 * exp(ETA(3)+ ETA3) * (BW / 72.9) ;
double V3 = TVV3 * exp(ETA(4)+ ETA4) ;

ALAG_DEPOT = ALAG ;

$OMEGA
0.562500 // 1 LAG
0.152881 // 2 CL
0.078400 // 3 VC
1.040400 // 4 VP

$SIGMA
0.126025
0

$TABLE
double DV = 1000 * CENT/V2 * (1 + EPS(1)) + EPS(2);

$PKMODEL ncmt = 2, depot = TRUE

$CAPTURE DV, CL