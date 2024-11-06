# D.Ntounis, Oct. 2024: assuming same resolution as in ILD card: https://github.com/delphes/delphes/blob/master/cards/ILCgen/ILCgen_BeamCal_Resolution.tcl

# P.Sopicki, corrected by A.F.Zarnecki
# BeamCal resolution

set ResolutionFormula {
(abs(eta) > 4.0 && abs(eta) <= 4.8) * sqrt(energy^2*0.02^2 + energy*0.30^2) +
(abs(eta) > 4.8 && abs(eta) <= 5.8) * sqrt(energy^2*0.03^2 + energy*0.45^2) 
}