# D.Ntounis, Oct. 2024: assuming same binning as in ILD card: https://github.com/delphes/delphes/blob/master/cards/ILCgen/ILCgen_LumiCalR_Binning.tcl

#P.Sopicki: based on plots from D.Jeans:

set pi [expr {acos(-1)} ]

# LumiCal eta range 3.0 - 4.0 (no beam crossing boost)
# Rear part
#Jim: from ILC TDR: "The azimuthal division is 36 with each sensor covering 10 degrees."

set PhiBins {}
  for {set i -18} {$i <= } {incr i} {
    add PhiBins [expr {$i * $pi/18.0} ]
  }

for {set i 0} {$i <= 64} {incr i} {
    set eta [expr {-4.0 + $i * 1.0/64.0} ]
    add EtaPhiBins $eta $PhiBins
  }