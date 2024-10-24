# Written by Chris Potter for the DSiD Delphes card
# reorganized by Dimitris Ntounis

  #CP reference Figure II-10.7
  set EfficiencyFormula { (abs(eta)<=1.01)*0.98+
      (abs(eta)>1.01&&abs(eta)<=1.32)*0.75+
      (abs(eta)>1.32&&abs(eta)<=2.44)*0.95+
      (abs(eta)>2.44)*0.0}
