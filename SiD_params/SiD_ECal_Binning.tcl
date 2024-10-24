  set pi [expr {acos(-1)}]


  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edge of the last tower

  # 0.5 degree towers (5x5 mm^2)
  set PhiBins {}
  for {set i -360} {$i <= 360} {incr i} {
    add PhiBins [expr {$i * $pi/360.0}]
  }

  # 0.01 unit in eta up to eta = 2.5
  for {set i -500} {$i <= 500} {incr i} {
    set eta [expr {$i * 0.005}]
    add EtaPhiBins $eta $PhiBins
  }
