# Written by Chris Potter for the DSiD Delphes card
# reorganized by Dimitris Ntounis

  # CP reference Figure II-10.6
  set EfficiencyFormula { (abs(eta)<=1.01)*0.99+
      (abs(eta)>1.01&&abs(eta)<=1.32)*0.95+
      (abs(eta)>1.32&&abs(eta)<=2.44)*0.99+
      (abs(eta)>2.44)*0.0}
