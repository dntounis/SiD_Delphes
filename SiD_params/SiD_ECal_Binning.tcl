  set pi [expr {acos(-1)}]


  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edge of the last tower

  # Cell size: assume 50 μm x 50 μm MAPS up to eta max = 2.5
  # This correspond to the pixel size but the actual xy resolution will be larger,
  # driven by the Moliere radius
  # We assume spatial resolution 1 mm x 1 mm in the xy plane



  # ECal Barrel : rinner = 126.5 cm, router = 140.9cm --> r_mid = 133.7 cm


  # DeltaEtaPhi = cell_size / r_mid = 1e-3 / 133.7e-2 = 0.00075


  # Number of bins in eta = 2*2.5 / 0.00075 ~ 6,600
  # Number of bins in phi = 2*pi / (0.00075*cosh(1.25)) ~ 4,400 (1.25 == eta_mid)

  set EtaPhiRes 0.00075
  # number of bins in each side (half of the total!!!)
  set nbins_phi 2200 
  set nbins_eta 3300

  set PhiBins {}
  for {set i -$nbins_phi} {$i <= $nbins_phi} {incr i} {
    add PhiBins [expr {$i * $pi/$nbins_phi}]
  }

  for {set i -$nbins_eta} {$i <= $nbins_eta} {incr i} {
    set eta [expr {$i * $EtaPhiRes}]
    add EtaPhiBins $eta $PhiBins
  }
