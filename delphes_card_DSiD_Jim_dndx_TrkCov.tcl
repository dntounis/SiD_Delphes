############################################################
# DSiD: Delphes card with SiD performance parameters
# Responsible: Chris Potter
# DSiD does not enforce electron, muon and photon isolation
# Reference: ILC Technical Design Report Volume 4: Detectors
# Adapted from the Delphes card delphes_card_ILD.tcl
############################################################

#######################################
# Order of execution of various modules
#######################################

set B 5.0
set R 2.493
set HL 3.018


set ExecutionPath {

  TruthVertexFinder
  ParticlePropagator

  ChargedHadronTrackingEfficiency
  ElectronTrackingEfficiency
  MuonTrackingEfficiency

  TrackMergerPre
  TrackSmearing
  ClusterCounting
  TimeSmearing
  TimeOfFlight

  TrackMerger

  ECal
  HCal

  TimeSmearingNeutrals
  TimeOfFlightNeutralHadron

  EFlowTrackMerger
  EFlowMerger

  PhotonEfficiency
  PhotonIsolation

  MuonFilter
  TowerMerger

  ElectronFilter
  ElectronEfficiency
  ElectronIsolation

  MuonEfficiency
  MuonIsolation

  MissingET

  NeutrinoFilter
  GenJetFinder
  GenMissingET

  FastJetFinder
  JetEnergyScale

  GenJetFinderDurhamN2
  FastJetFinderDurhamN2

  JetFlavorAssociation

  BTagging
  CTagging
  TauTagging

  UniqueObjectFinder
  TreeWriter
}

#################################
# Truth Vertex Finder
#################################

module TruthVertexFinder TruthVertexFinder {

  ## below this distance two vertices are assumed to be merged
  set Resolution 1E-06

  set InputArray Delphes/stableParticles
  set VertexOutputArray vertices
}


#################################
# Propagate particles in cylinder
#################################

module ParticlePropagator ParticlePropagator {
  set InputArray Delphes/stableParticles

  set OutputArray stableParticles
  set ChargedHadronOutputArray chargedHadrons
  set ElectronOutputArray electrons
  set MuonOutputArray muons
  # radius of the magnetic field coverage, in m
  set Radius $R
  # half-length of the magnetic field coverage, in m
  set HalfLength $HL
  # CP outer radii of the SiD HCAL 
  # CP reference Table II-1.1
  # magnetic field
  set Bz  $B
}

####################################
# Charged hadron tracking efficiency
####################################

module Efficiency ChargedHadronTrackingEfficiency {
  set InputArray ParticlePropagator/chargedHadrons
  set OutputArray chargedHadrons
  set UseMomentumVector true

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
}

##############################
# Electron tracking efficiency
##############################

module Efficiency ElectronTrackingEfficiency {
  set InputArray ParticlePropagator/electrons
  set OutputArray electrons
  set UseMomentumVector true

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
}

##########################
# Muon tracking efficiency
##########################

module Efficiency MuonTrackingEfficiency {
  set InputArray ParticlePropagator/muons
  set OutputArray muons
  set UseMomentumVector true

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
}

########################################
# Momentum resolution for charged tracks
########################################

module MomentumSmearing ChargedHadronMomentumSmearing {
  set InputArray ChargedHadronTrackingEfficiency/chargedHadrons
  set OutputArray chargedHadrons
  # CP reference Figure II-3.9 (only muon resolutions are available)
  set ResolutionFormula {(abs(eta)<=1.32)*sqrt(0.0000146^2*pt^2+0.00217^2)+
                         (abs(eta)>1.32)*sqrt(0.0000237^2*pt^2+0.00423^2) }     
}

###################################
# Momentum resolution for electrons
###################################

module MomentumSmearing ElectronMomentumSmearing {
  set InputArray ElectronTrackingEfficiency/electrons
  set OutputArray electrons
  # CP reference Figure II-3.9 (only muon resolutions are available)
  set ResolutionFormula {(abs(eta)<=1.32)*sqrt(0.0000146^2*pt^2+0.00217^2)+
                         (abs(eta)>1.32)*sqrt(0.0000237^2*pt^2+0.00423^2) }  
}

###############################
# Momentum resolution for muons
###############################

module MomentumSmearing MuonMomentumSmearing {
  set InputArray MuonTrackingEfficiency/muons
  set OutputArray muons
  # CP reference Figure II-3.9 (only muon resolutions are available)
  set ResolutionFormula {(abs(eta)<=1.32)*sqrt(0.0000146^2*pt^2+0.00217^2)+
                         (abs(eta)>1.32)*sqrt(0.0000237^2*pt^2+0.00423^2) }  
}

##############
# Track merger
##############

module Merger TrackMergerPre {
# add InputArray InputArray
  #add InputArray ChargedHadronMomentumSmearing/chargedHadrons
  #add InputArray ElectronMomentumSmearing/electrons
  #add InputArray MuonMomentumSmearing/muons
  add InputArray ChargedHadronTrackingEfficiency/chargedHadrons
  add InputArray ElectronTrackingEfficiency/electrons
  add InputArray MuonTrackingEfficiency/muons  
  set OutputArray tracks
}



########################################
# Smearing for charged tracks
########################################

module TrackCovariance TrackSmearing {

    set InputArray TrackMergerPre/tracks
    set OutputArray tracks

    ## minimum number of hits to accept a track
    set NMinHits 1

    ## magnetic field
    set Bz $B

    ## scale factors
    #set ElectronScaleFactor  {1.25}


    set DetectorGeometry {

      # Layer type 1 = R (barrel) or 2 = z (forward/backward)
      # Layer label
      # Minimum dimension z for barrel or R for forward
      # Maximum dimension z for barrel or R for forward
      # R/z location of layer
      # Thickness (meters)
      # Radiation length (meters)
      # Number of measurements in layers (1D or 2D)
      # Stereo angle (rad) - 0(pi/2) = axial(z) layer - Upper side
      # Stereo angle (rad) - 0(pi/2) = axial(z) layer - Lower side
      # Resolution Upper side (meters) - 0 = no measurement
      # Resolution Lower side (meters) - 0 = no measurement
      # measurement flag = T, scattering only = F

      # barrel  name       zmin   zmax   r        w (m)      X0        n_meas  th_up (rad) th_down (rad)    reso_up (m)   reso_down (m)  flag

      1 PIPE -100 100 0.01 0.00235 0.35276 0 0 0 0 0 0
      1 VTXLOW -0.0965 0.0965 0.012 0.00028 0.0937 2 0 1.5708 3e-06 3e-06 1
      1 VTXLOW -0.1609 0.1609 0.02 0.00028 0.0937 2 0 1.5708 3e-06 3e-06 1
      1 VTXLOW -0.2575 0.2575 0.031525 0.00028 0.0937 2 0 1.5708 3e-06 3e-06 1
      1 VTXLOW -0.1609 0.1609 0.15 0.00028 0.0937 2 0 1.5708 3e-06 3e-06 1
      1 VTXHIGH -0.3263 0.3263 0.315 0.00047 0.0937 2 0 1.5708 7e-06 7e-06 1
      1 DCHCANI -2.125 2.125 0.345 0.0002 0.237223 0 0 0 0 0 0
      1 DCH -2 2 0.36 0.0147748 1400 1 0.0203738 0 0.0001 0 1
      1 DCH -2 2 0.374775 0.0147748 1400 1 -0.0212097 0 0.0001 0 1
      1 DCH -2 2 0.38955 0.0147748 1400 1 0.0220456 0 0.0001 0 1
      1 DCH -2 2 0.404324 0.0147748 1400 1 -0.0228814 0 0.0001 0 1
      1 DCH -2 2 0.419099 0.0147748 1400 1 0.0237172 0 0.0001 0 1
      1 DCH -2 2 0.433874 0.0147748 1400 1 -0.024553 0 0.0001 0 1
      1 DCH -2 2 0.448649 0.0147748 1400 1 0.0253888 0 0.0001 0 1
      1 DCH -2 2 0.463423 0.0147748 1400 1 -0.0262245 0 0.0001 0 1
      1 DCH -2 2 0.478198 0.0147748 1400 1 0.0270602 0 0.0001 0 1
      1 DCH -2 2 0.492973 0.0147748 1400 1 -0.0278958 0 0.0001 0 1
      1 DCH -2 2 0.507748 0.0147748 1400 1 0.0287314 0 0.0001 0 1
      1 DCH -2 2 0.522523 0.0147748 1400 1 -0.029567 0 0.0001 0 1
      1 DCH -2 2 0.537297 0.0147748 1400 1 0.0304025 0 0.0001 0 1
      1 DCH -2 2 0.552072 0.0147748 1400 1 -0.031238 0 0.0001 0 1
      1 DCH -2 2 0.566847 0.0147748 1400 1 0.0320734 0 0.0001 0 1
      1 DCH -2 2 0.581622 0.0147748 1400 1 -0.0329088 0 0.0001 0 1
      1 DCH -2 2 0.596396 0.0147748 1400 1 0.0337442 0 0.0001 0 1
      1 DCH -2 2 0.611171 0.0147748 1400 1 -0.0345795 0 0.0001 0 1
      1 DCH -2 2 0.625946 0.0147748 1400 1 0.0354147 0 0.0001 0 1
      1 DCH -2 2 0.640721 0.0147748 1400 1 -0.0362499 0 0.0001 0 1
      1 DCH -2 2 0.655495 0.0147748 1400 1 0.0370851 0 0.0001 0 1
      1 DCH -2 2 0.67027 0.0147748 1400 1 -0.0379202 0 0.0001 0 1
      1 DCH -2 2 0.685045 0.0147748 1400 1 0.0387552 0 0.0001 0 1
      1 DCH -2 2 0.69982 0.0147748 1400 1 -0.0395902 0 0.0001 0 1
      1 DCH -2 2 0.714595 0.0147748 1400 1 0.0404252 0 0.0001 0 1
      1 DCH -2 2 0.729369 0.0147748 1400 1 -0.04126 0 0.0001 0 1
      1 DCH -2 2 0.744144 0.0147748 1400 1 0.0420949 0 0.0001 0 1
      1 DCH -2 2 0.758919 0.0147748 1400 1 -0.0429296 0 0.0001 0 1
      1 DCH -2 2 0.773694 0.0147748 1400 1 0.0437643 0 0.0001 0 1
      1 DCH -2 2 0.788468 0.0147748 1400 1 -0.044599 0 0.0001 0 1
      1 DCH -2 2 0.803243 0.0147748 1400 1 0.0454336 0 0.0001 0 1
      1 DCH -2 2 0.818018 0.0147748 1400 1 -0.0462681 0 0.0001 0 1
      1 DCH -2 2 0.832793 0.0147748 1400 1 0.0471025 0 0.0001 0 1
      1 DCH -2 2 0.847568 0.0147748 1400 1 -0.0479369 0 0.0001 0 1
      1 DCH -2 2 0.862342 0.0147748 1400 1 0.0487713 0 0.0001 0 1
      1 DCH -2 2 0.877117 0.0147748 1400 1 -0.0496055 0 0.0001 0 1
      1 DCH -2 2 0.891892 0.0147748 1400 1 0.0504397 0 0.0001 0 1
      1 DCH -2 2 0.906667 0.0147748 1400 1 -0.0512738 0 0.0001 0 1
      1 DCH -2 2 0.921441 0.0147748 1400 1 0.0521079 0 0.0001 0 1
      1 DCH -2 2 0.936216 0.0147748 1400 1 -0.0529418 0 0.0001 0 1
      1 DCH -2 2 0.950991 0.0147748 1400 1 0.0537757 0 0.0001 0 1
      1 DCH -2 2 0.965766 0.0147748 1400 1 -0.0546095 0 0.0001 0 1
      1 DCH -2 2 0.980541 0.0147748 1400 1 0.0554433 0 0.0001 0 1
      1 DCH -2 2 0.995315 0.0147748 1400 1 -0.056277 0 0.0001 0 1
      1 DCH -2 2 1.01009 0.0147748 1400 1 0.0571106 0 0.0001 0 1
      1 DCH -2 2 1.02486 0.0147748 1400 1 -0.0579441 0 0.0001 0 1
      1 DCH -2 2 1.03964 0.0147748 1400 1 0.0587775 0 0.0001 0 1
      1 DCH -2 2 1.05441 0.0147748 1400 1 -0.0596108 0 0.0001 0 1
      1 DCH -2 2 1.06919 0.0147748 1400 1 0.0604441 0 0.0001 0 1
      1 DCH -2 2 1.08396 0.0147748 1400 1 -0.0612773 0 0.0001 0 1
      1 DCH -2 2 1.09874 0.0147748 1400 1 0.0621104 0 0.0001 0 1
      1 DCH -2 2 1.11351 0.0147748 1400 1 -0.0629434 0 0.0001 0 1
      1 DCH -2 2 1.12829 0.0147748 1400 1 0.0637763 0 0.0001 0 1
      1 DCH -2 2 1.14306 0.0147748 1400 1 -0.0646092 0 0.0001 0 1
      1 DCH -2 2 1.15784 0.0147748 1400 1 0.0654419 0 0.0001 0 1
      1 DCH -2 2 1.17261 0.0147748 1400 1 -0.0662746 0 0.0001 0 1
      1 DCH -2 2 1.18739 0.0147748 1400 1 0.0671071 0 0.0001 0 1
      1 DCH -2 2 1.20216 0.0147748 1400 1 -0.0679396 0 0.0001 0 1
      1 DCH -2 2 1.21694 0.0147748 1400 1 0.068772 0 0.0001 0 1
      1 DCH -2 2 1.23171 0.0147748 1400 1 -0.0696042 0 0.0001 0 1
      1 DCH -2 2 1.24649 0.0147748 1400 1 0.0704364 0 0.0001 0 1
      1 DCH -2 2 1.26126 0.0147748 1400 1 -0.0712685 0 0.0001 0 1
      1 DCH -2 2 1.27604 0.0147748 1400 1 0.0721005 0 0.0001 0 1
      1 DCH -2 2 1.29081 0.0147748 1400 1 -0.0729324 0 0.0001 0 1
      1 DCH -2 2 1.30559 0.0147748 1400 1 0.0737642 0 0.0001 0 1
      1 DCH -2 2 1.32036 0.0147748 1400 1 -0.0745958 0 0.0001 0 1
      1 DCH -2 2 1.33514 0.0147748 1400 1 0.0754274 0 0.0001 0 1
      1 DCH -2 2 1.34991 0.0147748 1400 1 -0.0762589 0 0.0001 0 1
      1 DCH -2 2 1.36468 0.0147748 1400 1 0.0770903 0 0.0001 0 1
      1 DCH -2 2 1.37946 0.0147748 1400 1 -0.0779215 0 0.0001 0 1
      1 DCH -2 2 1.39423 0.0147748 1400 1 0.0787527 0 0.0001 0 1
      1 DCH -2 2 1.40901 0.0147748 1400 1 -0.0795837 0 0.0001 0 1
      1 DCH -2 2 1.42378 0.0147748 1400 1 0.0804147 0 0.0001 0 1
      1 DCH -2 2 1.43856 0.0147748 1400 1 -0.0812455 0 0.0001 0 1
      1 DCH -2 2 1.45333 0.0147748 1400 1 0.0820762 0 0.0001 0 1
      1 DCH -2 2 1.46811 0.0147748 1400 1 -0.0829068 0 0.0001 0 1
      1 DCH -2 2 1.48288 0.0147748 1400 1 0.0837373 0 0.0001 0 1
      1 DCH -2 2 1.49766 0.0147748 1400 1 -0.0845677 0 0.0001 0 1
      1 DCH -2 2 1.51243 0.0147748 1400 1 0.0853979 0 0.0001 0 1
      1 DCH -2 2 1.52721 0.0147748 1400 1 -0.086228 0 0.0001 0 1
      1 DCH -2 2 1.54198 0.0147748 1400 1 0.087058 0 0.0001 0 1
      1 DCH -2 2 1.55676 0.0147748 1400 1 -0.0878879 0 0.0001 0 1
      1 DCH -2 2 1.57153 0.0147748 1400 1 0.0887177 0 0.0001 0 1
      1 DCH -2 2 1.58631 0.0147748 1400 1 -0.0895474 0 0.0001 0 1
      1 DCH -2 2 1.60108 0.0147748 1400 1 0.0903769 0 0.0001 0 1
      1 DCH -2 2 1.61586 0.0147748 1400 1 -0.0912063 0 0.0001 0 1
      1 DCH -2 2 1.63063 0.0147748 1400 1 0.0920356 0 0.0001 0 1
      1 DCH -2 2 1.64541 0.0147748 1400 1 -0.0928647 0 0.0001 0 1
      1 DCH -2 2 1.66018 0.0147748 1400 1 0.0936937 0 0.0001 0 1
      1 DCH -2 2 1.67495 0.0147748 1400 1 -0.0945226 0 0.0001 0 1
      1 DCH -2 2 1.68973 0.0147748 1400 1 0.0953514 0 0.0001 0 1
      1 DCH -2 2 1.7045 0.0147748 1400 1 -0.09618 0 0.0001 0 1
      1 DCH -2 2 1.71928 0.0147748 1400 1 0.0970085 0 0.0001 0 1
      1 DCH -2 2 1.73405 0.0147748 1400 1 -0.0978369 0 0.0001 0 1
      1 DCH -2 2 1.74883 0.0147748 1400 1 0.0986651 0 0.0001 0 1
      1 DCH -2 2 1.7636 0.0147748 1400 1 -0.0994932 0 0.0001 0 1
      1 DCH -2 2 1.77838 0.0147748 1400 1 0.100321 0 0.0001 0 1
      1 DCH -2 2 1.79315 0.0147748 1400 1 -0.101149 0 0.0001 0 1
      1 DCH -2 2 1.80793 0.0147748 1400 1 0.101977 0 0.0001 0 1
      1 DCH -2 2 1.8227 0.0147748 1400 1 -0.102804 0 0.0001 0 1
      1 DCH -2 2 1.83748 0.0147748 1400 1 0.103632 0 0.0001 0 1
      1 DCH -2 2 1.85225 0.0147748 1400 1 -0.104459 0 0.0001 0 1
      1 DCH -2 2 1.86703 0.0147748 1400 1 0.105286 0 0.0001 0 1
      1 DCH -2 2 1.8818 0.0147748 1400 1 -0.106113 0 0.0001 0 1
      1 DCH -2 2 1.89658 0.0147748 1400 1 0.10694 0 0.0001 0 1
      1 DCH -2 2 1.91135 0.0147748 1400 1 -0.107766 0 0.0001 0 1
      1 DCH -2 2 1.92613 0.0147748 1400 1 0.108593 0 0.0001 0 1
      1 DCH -2 2 1.9409 0.0147748 1400 1 -0.109419 0 0.0001 0 1
      1 DCH -2 2 1.95568 0.0147748 1400 1 0.110246 0 0.0001 0 1
      1 DCH -2 2 1.97045 0.0147748 1400 1 -0.111072 0 0.0001 0 1
      1 DCH -2 2 1.98523 0.0147748 1400 1 0.111898 0 0.0001 0 1
      1 DCH -2 2 2 0.0147748 1400 1 -0.112723 0 0.0001 0 1
      1 DCHCANO -2.125 2.125 2.02 0.02 1.667 0 0 0 0 0 0
      1 BSILWRP -2.35 2.35 2.04 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      1 BSILWRP -2.35 2.35 2.06 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      1 MAG -2.5 2.5 2.25 0.05 0.0658 0 0 0 0 0 0
      1 BPRESH -2.55 2.55 2.45 0.02 1 2 0 1.5708 7e-05 0.01 1
      2 VTXDSK 0.105 0.29 -0.93 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 VTXDSK 0.075 0.29 -0.62 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 VTXDSK 0.0365 0.2515 -0.2575 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 VTXDSK 0.0365 0.2515 0.2575 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 VTXDSK 0.075 0.29 0.62 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 VTXDSK 0.105 0.29 0.93 0.00028 0.0937 2 0 1.5708 7e-06 7e-06 1
      2 DCHWALL 0.345 2.02 2.125 0.25 5.55 0 0 0 0 0 0
      2 DCHWALL 0.345 2.02 -2.125 0.25 5.55 0 0 0 0 0 0
      2 FSILWRP 0.354 2.02 -2.32 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      2 FSILWRP 0.35 2.02 -2.3 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      2 FSILWRP 0.35 2.02 2.3 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      2 FSILWRP 0.354 2.02 2.32 0.00047 0.0937 2 0 1.5708 7e-06 9e-05 1
      2 FRAD 0.38 2.09 2.49 0.0043 0.005612 0 0 0 0 0 0
      2 FRAD 0.38 2.09 -2.49 0.0043 0.005612 0 0 0 0 0 0
      2 FPRESH 0.39 2.43 -2.55 0.02 1 2 0 1.5708 7e-05 0.01 1
      2 FPRESH 0.39 2.43 2.55 0.02 1 2 0 1.5708 7e-05 0.01 1
    }

}





###################
# Cluster Counting
###################

module ClusterCounting ClusterCounting {

  add InputArray TrackMergerPre/tracks
  #set InputArray TrackSmearing/tracks
  set OutputArray tracks

  set Bz $B

  ## check that these are consistent with DCHCANI/DCHNANO parameters in TrackCovariance module
  set Rmin 0.00001
  set Rmax 0.00002
  set Zmin -0.00001
  set Zmax 0.00001

  # gas mix option:
  # 0:  Helium 90% - Isobutane 10%
  # 1:  Helium 100%
  # 2:  Argon 50% - Ethane 50%
  # 3:  Argon 100%

  set GasOption 0

}


########################################
#   Time Smearing MIP
########################################

module TimeSmearing TimeSmearing {
  set InputArray ClusterCounting/tracks
  set OutputArray tracks

  # Jim: assume constant 1000 ps resolution for now
  set TimeResolution {
                       (abs(eta) > 0.0 && abs(eta) <= 3.0)* 1000E-12
                     }
}

########################################
#   Time Of Flight Measurement
########################################

module TimeOfFlight TimeOfFlight {
  set InputArray TimeSmearing/tracks
  set VertexInputArray TruthVertexFinder/vertices

  set OutputArray tracks

  # 0: assume vertex time tV from MC Truth (ideal case)
  # 1: assume vertex time tV = 0
  # 2: calculate vertex time as vertex TOF, assuming tPV=0

  set VertexTimeMode 0
}


##############
# Track merger
##############

module Merger TrackMerger {
# add InputArray InputArray
  add InputArray TimeOfFlight/tracks
  set OutputArray tracks
}



#############
#   ECAL
#############

module SimpleCalorimeter ECal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray TrackMerger/tracks

  set TowerOutputArray ecalTowers
  set PhotonOutputArray photons
  #Jim 

  set EFlowTrackOutputArray eflowTracks
  set EFlowTowerOutputArray eflowPhotons
  #set EFlowPhotonOutputArray eflowPhotons


  set IsEcal true
  set EnergyMin 0.5
  set EnergySignificanceMin 1.0
  set SmearTowerCenter true
  set pi [expr {acos(-1)}]

  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edged of the last tower

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

  # default energy fractions {abs(PDG code)} {fraction of energy deposited in ECAL}
  add EnergyFraction {0} {0.0}
  # energy fractions for e, gamma and pi0
  add EnergyFraction {11} {1.0}
  add EnergyFraction {22} {1.0}
  add EnergyFraction {111} {1.0}
  # energy fractions for muon, neutrinos and neutralinos
  add EnergyFraction {12} {0.0}
  add EnergyFraction {13} {0.0}
  add EnergyFraction {14} {0.0}
  add EnergyFraction {16} {0.0}
  add EnergyFraction {1000022} {0.0}
  add EnergyFraction {1000023} {0.0}
  add EnergyFraction {1000025} {0.0}
  add EnergyFraction {1000035} {0.0}
  add EnergyFraction {1000045} {0.0}
  # energy fractions for K0short and Lambda
  add EnergyFraction {310} {0.3}
  add EnergyFraction {3122} {0.3}

  # set ECalResolutionFormula {resolution formula as a function of eta and energy}
  # CP reference Table II-4.1
  set ResolutionFormula {sqrt(energy^2*0.01^2 + energy*0.17^2)}

}

#############
#   HCAL
#############

module SimpleCalorimeter HCal {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray ECal/eflowTracks
  #Jim
  #set EFlowTrackInputArray ECal/eflowTracks

  set TowerOutputArray hcalTowers
  set EFlowTrackOutputArray eflowTracks

  set EFlowTowerOutputArray eflowNeutralHadrons
  #Jim
  #set EFlowNeutralHadronOutputArray eflowNeutralHadrons


  set IsEcal false
  set EnergyMin 1.0
  set EnergySignificanceMin 1.0
  set SmearTowerCenter true
  set pi [expr {acos(-1)}]

  # lists of the edges of each tower in eta and phi
  # each list starts with the lower edge of the first tower
  # the list ends with the higher edged of the last tower

  # 6 degree towers
  set PhiBins {}
  for {set i -60} {$i <= 60} {incr i} {
    add PhiBins [expr {$i * $pi/60.0}]
  }

  # 0.5 unit in eta up to eta = 3
  for {set i -60} {$i <= 60} {incr i} {
    set eta [expr {$i * 0.05}]
    add EtaPhiBins $eta $PhiBins
  }

  # default energy fractions {abs(PDG code)} {Fecal Fhcal}
  add EnergyFraction {0} {1.0}
  # energy fractions for e, gamma and pi0
  add EnergyFraction {11} {0.0}
  add EnergyFraction {22} {0.0}
  add EnergyFraction {111} {0.0}
  # energy fractions for muon, neutrinos and neutralinos
  add EnergyFraction {12} {0.0}
  add EnergyFraction {13} {0.0}
  add EnergyFraction {14} {0.0}
  add EnergyFraction {16} {0.0}
  add EnergyFraction {1000022} {0.0}
  add EnergyFraction {1000023} {0.0}
  add EnergyFraction {1000025} {0.0}
  add EnergyFraction {1000035} {0.0}
  add EnergyFraction {1000045} {0.0}
  # energy fractions for K0short and Lambda
  add EnergyFraction {310} {0.7}
  add EnergyFraction {3122} {0.7}

  # set HCalResolutionFormula {resolution formula as a function of eta and energy}
  # CP reference Figure II-4.15
  set ResolutionFormula {sqrt(energy^2*0.094^2 + energy*0.559^2)}
  #set ResolutionFormula {(abs(eta) <= 3.0) * sqrt(energy^2*0.015^2 + energy*0.50^2)}                 
}


########################################
#   Time Smearing Neutrals
########################################

module TimeSmearing TimeSmearingNeutrals {
  set InputArray HCal/eflowNeutralHadrons
  set OutputArray eflowNeutralHadrons

  #Jim:  assume constant 1000ps resolution for now
  set TimeResolution {
                       (abs(eta) > 0.0 && abs(eta) <= 3.0)* 1000E-12
                     }
}



########################################
#   Time Of Flight Measurement
########################################

module TimeOfFlight TimeOfFlightNeutralHadron {
  set InputArray TimeSmearingNeutrals/eflowNeutralHadrons
  set VertexInputArray TruthVertexFinder/vertices

  set OutputArray eflowNeutralHadrons

  # 0: assume vertex time tV from MC Truth (ideal case)
  # 1: assume vertex time tV = 0
  # 2: calculate vertex time as vertex TOF, assuming tPV=0

  ## TBF (add option to take hard vertex time)
  set VertexTimeMode 1
}





#################
# Electron filter
#################

module PdgCodeFilter ElectronFilter {
  set InputArray EFlowTrackMerger/eflowTracks
  set OutputArray electrons
  set Invert true
  add PdgCode {11}
  add PdgCode {-11}
}

#################
# Muon filter
#################

module PdgCodeFilter MuonFilter {
  set InputArray EFlowTrackMerger/eflowTracks
  set OutputArray muons
  set Invert true
  add PdgCode {13}
  add PdgCode {-13}
}




############################
# Jim: Energy flow track merger
############################

module Merger EFlowTrackMerger {
# add InputArray InputArray
  #add InputArray ECal/eflowTracks
  add InputArray HCal/eflowTracks
  set OutputArray eflowTracks
}

# Energy flow merger
####################

module Merger EFlowMerger {
# add InputArray InputArray
  #add InputArray HCal/eflowTracks
  add InputArray EFlowTrackMerger/eflowTracks
  add InputArray ECal/eflowPhotons
  #add InputArray HCal/eflowNeutralHadrons
  add InputArray TimeOfFlightNeutralHadron/eflowNeutralHadrons
  set OutputArray eflow
}

###################################################
# Tower Merger (in case not using e-flow algorithm)
###################################################

module Merger TowerMerger {
# add InputArray InputArray
  add InputArray ECal/ecalTowers
  add InputArray HCal/hcalTowers
  #Jim
  add InputArray MuonFilter/muons
  set OutputArray towers
}



###################
# Missing ET merger
###################

module Merger MissingET {
# add InputArray InputArray
  add InputArray EFlowMerger/eflow
  set MomentumOutputArray momentum
}

##################
# Scalar HT merger
##################

module Merger ScalarHT {
# add InputArray InputArray
  add InputArray EFlowMerger/eflow
  set EnergyOutputArray energy
}

#################
# Neutrino Filter
#################

module PdgCodeFilter NeutrinoFilter {
  set InputArray Delphes/stableParticles
  set OutputArray filteredParticles
  set PTMin 0.0
  add PdgCode {12}
  add PdgCode {14}
  add PdgCode {16}
  add PdgCode {-12}
  add PdgCode {-14}
  add PdgCode {-16}
}

#########################
# Gen Missing ET merger
########################

module Merger GenMissingET {
# add InputArray InputArray
  add InputArray NeutrinoFilter/filteredParticles
  set MomentumOutputArray momentum
}


#####################
# MC truth jet finder
#####################

module FastJetFinder GenJetFinder {
  set InputArray NeutrinoFilter/filteredParticles
  set OutputArray jets
  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  
  #Jim
  #set JetAlgorithm 6
  #set ParameterR 1.0
  #set JetPTMin 10.0

  set JetAlgorithm 10
  set ParameterR 1.5
  set ParameterP -1.0
  set JetPTMin 1.0

}

############
# Jet finder
############

module FastJetFinder FastJetFinder {
  #set InputArray TowerMerger/towers
  set InputArray EFlowMerger/eflow
  set OutputArray jets
  # algorithm: 1 CDFJetClu, 2 MidPoint, 3 SIScone, 4 kt, 5 Cambridge/Aachen, 6 antikt
  #Jim 
  #set JetAlgorithm 6
  #set ParameterR 1.0
  #set JetPTMin 10.0
  set JetAlgorithm 10
  set ParameterR 1.5
  set ParameterP -1.0
  set JetPTMin 1.0


}

##################
# Jet Energy Scale
##################

module EnergyScale JetEnergyScale {
  set InputArray FastJetFinder/jets
  set OutputArray jets
 # scale formula for jets
  set ScaleFormula {1.00}
}



###################################
# Gen Jet finder Durham exclusive
###################################

module FastJetFinder GenJetFinderDurhamN2 {

  set InputArray NeutrinoFilter/filteredParticles
  set OutputArray jets

  # algorithm: 11 ee-durham kT algorithm
  # ref: https://indico.cern.ch/event/1173562/contributions/4929025/attachments/2470068/4237859/2022-06-FCC-jets.pdf
  # to run exclusive njet mode set NJets to int
  # to run exclusive dcut mode set DCut to float
  # if DCut > 0 will run in dcut mode

  set JetAlgorithm 11
  set ExclusiveClustering true
  set NJets 2
  # set DCut 10.0
}


################################
# Jet finder Durham exclusive
################################

module FastJetFinder FastJetFinderDurhamN2 {
#  set InputArray Calorimeter/towers
  set InputArray EFlowMerger/eflow

  set OutputArray jets

  # algorithm: 11 ee-durham kT algorithm
  # ref: https://indico.cern.ch/event/1173562/contributions/4929025/attachments/2470068/4237859/2022-06-FCC-jets.pdf
  # to run exclusive njet mode set NJets to int
  # to run exclusive dcut mode set DCut to float
  # if DCut > 0 will run in dcut mode

  set JetAlgorithm 11
  set ExclusiveClustering true
  set NJets 2
  # set DCut 10.0

}












########################
# Jet Flavor Association
########################

module JetFlavorAssociation JetFlavorAssociation {
  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScale/jets
  set DeltaR 0.5
  set PartonPTMin 1.0
  set PartonEtaMax 2.5
}

###################
# Photon efficiency
###################

module Efficiency PhotonEfficiency {
  set InputArray ECal/eflowPhotons
  set OutputArray photons
  # CP reference Figure II-10.6
  set EfficiencyFormula { (abs(eta)<=1.01)*0.99+
      (abs(eta)>1.01&&abs(eta)<=1.32)*0.95+
      (abs(eta)>1.32&&abs(eta)<=2.44)*0.99+
      (abs(eta)>2.44)*0.0}
}

##################
# Photon isolation
##################

module Isolation PhotonIsolation {
  set CandidateInputArray PhotonEfficiency/photons
  set IsolationInputArray EFlowMerger/eflow
  set OutputArray photons
  #Jim
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 1000000.
}

#####################
# Electron efficiency
#####################

module Efficiency ElectronEfficiency {
  set InputArray ElectronFilter/electrons
  set OutputArray electrons
  #CP reference Figure II-10.7
  set EfficiencyFormula { (abs(eta)<=1.01)*0.98+
      (abs(eta)>1.01&&abs(eta)<=1.32)*0.75+
      (abs(eta)>1.32&&abs(eta)<=2.44)*0.95+
      (abs(eta)>2.44)*0.0}
}

####################
# Electron isolation
####################

module Isolation ElectronIsolation {
  set CandidateInputArray ElectronEfficiency/electrons
  set IsolationInputArray EFlowMerger/eflow
  set OutputArray electrons
  #Jim
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 1000000.
}

#################
# Muon efficiency
#################

module Efficiency MuonEfficiency {
  set InputArray MuonFilter/muons
  set OutputArray muons
  # CP reference II-10.8
  set EfficiencyFormula { (abs(eta)<=2.44)*0.98+0.0}
}

################
# Muon isolation
################

module Isolation MuonIsolation {
  set CandidateInputArray MuonEfficiency/muons
  set IsolationInputArray EFlowMerger/eflow
  set OutputArray muons
  #Jim
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 1000000.
}

###########
# b-tagging
###########

module BTagging BTagging {
  set JetInputArray JetEnergyScale/jets
  set BitNumber 0
  #CP reference II-10.9 b/c/l efficiency: (0.6/0.004/0.001, 0.7/0.02/0.003, 0.8/0.1/0.01, 0.9/0.3/0.05)
  add EfficiencyFormula {0} {(abs(eta)<2.17)*0.003+0.0}
  add EfficiencyFormula {4} {(abs(eta)<2.17)*0.02+0.0}
  add EfficiencyFormula {5} {(abs(eta)<2.17)*0.70+0.0}
}

# Jim: Copied from FCC -- check again
###########
# c-tagging
###########

module BTagging CTagging {
  set JetInputArray JetEnergyScale/jets

  set BitNumber 1

  # add EfficiencyFormula {abs(PDG code)} {efficiency formula as a function of eta and pt}

  # default efficiency formula (misidentification rate)
  add EfficiencyFormula {0} {0.01}

  # efficiency formula for c-jets (misidentification rate)
  add EfficiencyFormula {5} {0.05}

  # efficiency formula for b-jets
  add EfficiencyFormula {4} {0.80}
}


#############
# tau-tagging
#############

module TauTagging TauTagging {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set JetInputArray JetEnergyScale/jets
  set DeltaR 0.5
  set TauPTMin 1.0
  set TauEtaMax 4.0
  # default efficiency formula (misidentification rate)
  add EfficiencyFormula {0} {0.001}
  # efficiency formula for tau-jets
  add EfficiencyFormula {15} {0.4}
}

#####################################################
# Find uniquely identified photons/electrons/tau/jets
#####################################################

module UniqueObjectFinder UniqueObjectFinder {
# earlier arrays take precedence over later ones
# add InputArray InputArray OutputArray
  add InputArray PhotonIsolation/photons photons
  add InputArray ElectronIsolation/electrons electrons
  add InputArray MuonIsolation/muons muons
  add InputArray JetEnergyScale/jets jets
}

##################
# ROOT tree writer
##################

module TreeWriter TreeWriter {
# add Branch InputArray BranchName BranchClass
  add Branch Delphes/allParticles Particle GenParticle
  add Branch TruthVertexFinder/vertices GenVertex Vertex

  add Branch EFlowTrackMerger/eflowTracks EFlowTrack Track
  add Branch TrackSmearing/tracks Track Track
  add Branch ECal/eflowPhotons EFlowPhoton Tower
  add Branch TimeOfFlightNeutralHadron/eflowNeutralHadrons EFlowNeutralHadron Tower

  add Branch EFlowMerger/eflow ParticleFlowCandidate ParticleFlowCandidate
  add Branch TowerMerger/towers Tower Tower

  add Branch UniqueObjectFinder/electrons Electron Electron
  add Branch UniqueObjectFinder/muons Muon Muon
  add Branch UniqueObjectFinder/photons Photon Photon

  add Branch UniqueObjectFinder/jets Jet Jet
  add Branch MissingET/momentum MissingET MissingET

  add Branch GenJetFinder/jets GenJet Jet
  add Branch GenMissingET/momentum GenMissingET MissingET

  add Branch GenJetFinderDurhamN2/jets GenJetDurhamN2 Jet
  add Branch FastJetFinderDurhamN2/jets JetDurhamN2 Jet


 # add Branch ChargedHadronMomentumSmearing/chargedHadrons ChargedHadron Track
  #add Branch HCal/eflowNeutralHadrons EFlowNeutralHadron Tower 
  # Jim: change from NeutralHadron to EFlowNeutralHadron
  #add Branch ScalarHT/energy ScalarHT ScalarHT

    # add Info InfoName InfoValue
    add Info Bz $B

}


