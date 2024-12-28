# set HCalResolutionFormula {resolution formula as a function of eta and energy}
#Jim: change to AHCAL Scintillator-SiPM/steel resolution: https://arxiv.org/pdf/2110.09965
set ResolutionFormula {sqrt(energy^2*0.015^2 + energy*0.75^2)}
