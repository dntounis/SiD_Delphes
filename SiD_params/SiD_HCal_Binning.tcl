set pi [expr {acos(-1)}]

# lists of the edges of each tower in eta and phi
# each list starts with the lower edge of the first tower
# the list ends with the higher edge of the last tower

# Cell size: assume 3 cm x 3 cm  up to eta max = 3
# ECal Barrel : rinner = 141.7 cm, router = 249.3 cm --> r_mid = 195.5 cm


# DeltaEtaPhi = cell_size / r_mid = 3e-2 / 195.5e-2 = 0.015




# Number of bins in eta = 2*3.0 / 0.015 = 400
# Number of bins in phi = 2*pi / (0.015*cosh(1.5)) ~ 180

set EtaPhiRes 0.015

# number of bins in each side (half of the total!!!)
set nbins_phi 90  
set nbins_eta 200


set PhiBins {}
for {set i -$nbins_phi} {$i <= $nbins_phi} {incr i} {
  add PhiBins [expr {$i * $pi/$nbins_phi}]
}

for {set i -$nbins_eta} {$i <= $nbins_eta} {incr i} {
  set eta [expr {$i * $EtaPhiRes}]
  add EtaPhiBins $eta $PhiBins
}
