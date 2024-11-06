# Written by Chris Potter for the DSiD Delphes card
# reorganized by Dimitris Ntounis

  # CP reference Figure 11-3.5 left (only muon efficiencies are available)
  set EfficiencyFormula { (pt<=0.1)*0.0+
                          (abs(eta)<=1.32)*(pt>0.1&&pt<=0.6)*0.90+
                          (abs(eta)<=1.32)*(pt>0.6&&pt<=2.0)*0.98+
                          (abs(eta)<=1.32)*(pt>2.0&&pt<=4.0)*0.99+
                          (abs(eta)<=1.32)*(pt>4.0&&pt<=10000.)*0.99+
                          (abs(eta)<=2.44&&abs(eta)>1.32)*(pt>0.1&&pt<=0.6)*0.95+
                          (abs(eta)<=2.44&&abs(eta)>1.32)*(pt>0.6&&pt<=2.0)*0.99+
                          (abs(eta)<=2.44&&abs(eta)>1.32)*(pt>2.0&&pt<=4.0)*0.98+
                          (abs(eta)<=2.44&&abs(eta)>1.32)*(pt>4.0&&pt<=10000.)*(0.99-0.00021*(pt-4.))+
                          (abs(eta)>2.44)*0.0 }
