############################################################
# DSiD: Delphes card with SiD performance parameters
# Responsible: Chris Potter
# DSiD does not enforce electron, muon and photon isolation
# Reference: ILC Technical Design Report Volume 4: Detectors
# Adapted from the Delphes card delphes_card_ILD.tcl
# updated by Dimitris Ntounis: dntounis@slac.stanford.edu
# to include latest SiD developments: https://arxiv.org/pdf/2110.09965
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
  LumiCalF
  LumiCalR
  BeamCalF
  BeamCalR
  HCal

  TimeSmearingNeutrals
  TimeOfFlightNeutralHadron

  EFlowTrackMerger
  EFlowMerger

  PhotonEfficiency
  PhotonIsolation

  MuonFilter
  TowerMerger

  BCalTowerMerger
  BCalEFlowMerger
  BCalEfficiency

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

  source SiD_params/SiD_ChargedHadronTrackingEfficiency.tcl

}

##############################
# Electron tracking efficiency
##############################

module Efficiency ElectronTrackingEfficiency {
  set InputArray ParticlePropagator/electrons
  set OutputArray electrons
  set UseMomentumVector true

  # CP reference Figure 11-3.5 left (only muon efficiencies are available)
  source SiD_params/SiD_ChargedHadronTrackingEfficiency.tcl
 
}

##########################
# Muon tracking efficiency
##########################

module Efficiency MuonTrackingEfficiency {
  set InputArray ParticlePropagator/muons
  set OutputArray muons
  set UseMomentumVector true

  # CP reference Figure 11-3.5 left (only muon efficiencies are available)
  source SiD_params/SiD_ChargedHadronTrackingEfficiency.tcl
 
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

    ## magnetic field
    set Bz $B

    source SiD_params/SiD_TrackCovariance_1stvtx_10mm.tcl

}





###################
# Cluster Counting
###################

module ClusterCounting ClusterCounting {

  #add InputArray TrackMergerPre/tracks
  #Jim: change !!!!!!!!!!!!!!!!
  set InputArray TrackSmearing/tracks 
  set OutputArray tracks

  set Bz $B

  ## Jim: set to very small values to effectively have no ClusterCounting information
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


  set IsEcal true
  set EnergyMin 0.5
  set EnergySignificanceMin 1.0
  set SmearTowerCenter true

  source SiD_params/SiD_ECal_Binning.tcl

  source SiD_params/SiD_ECal_EnergyFractions.tcl

  source SiD_params/SiD_ECal_Resolution.tcl

}

##############
# LumiCal
##############
module SimpleCalorimeter LumiCalF {
    set ParticleInputArray ParticlePropagator/stableParticles
    set TrackInputArray TrackMerger/tracks
    
    set TowerOutputArray lumicalTowers
    set PhotonOutputArray photons


    set EFlowTrackOutputArray eflowTracks
    set EFlowTowerOutputArray eflowPhotons
    
    set IsEcal true 
    set EnergyMin 2.0
    set EnergySignificanceMin 1.0
    set SmearTowerCenter true
    
    source SiD_params/SiD_LumiCalF_Binning.tcl
    source SiD_params/SiD_ECal_EnergyFractions.tcl
    source SiD_params/SiD_ECal_Resolution.tcl
}

module SimpleCalorimeter LumiCalR {
    set ParticleInputArray ParticlePropagator/stableParticles
    set TrackInputArray TrackMerger/tracks
    
    set TowerOutputArray lumicalTowers
    set PhotonOutputArray photons


    set EFlowTrackOutputArray eflowTracks
    set EFlowTowerOutputArray eflowPhotons
    
    set IsEcal true 
    set EnergyMin 2.0
    set EnergySignificanceMin 1.0
    set SmearTowerCenter true
    
    source SiD_params/SiD_LumiCalR_Binning.tcl
    source SiD_params/SiD_ECal_EnergyFractions.tcl
    source SiD_params/SiD_ECal_Resolution.tcl
}

##############
# BeamCal
##############
module SimpleCalorimeter BeamCalR {
    set ParticleInputArray ParticlePropagator/stableParticles
    set TrackInputArray TrackMerger/tracks
    
    set TowerOutputArray bcalTowers

    set EFlowTowerOutputArray bcalPhotons
    
    set IsEcal true 
    
    set EnergyMin 5.0
    set EnergySignificanceMin 1.0
    
    set SmearTowerCenter true
    
    source SiD_params/SiD_BeamCalR_Binning.tcl
    source SiD_params/SiD_BeamCal_EnergyFractions.tcl
    source SiD_params/SiD_BeamCal_Resolution.tcl
}

module SimpleCalorimeter BeamCalF {
    set ParticleInputArray ParticlePropagator/stableParticles
    set TrackInputArray TrackMerger/tracks
    
    set TowerOutputArray bcalTowers

    set EFlowTowerOutputArray bcalPhotons
    
    set IsEcal true 
    
    set EnergyMin 5.0
    set EnergySignificanceMin 1.0
    
    set SmearTowerCenter true
    
    source SiD_params/SiD_BeamCalF_Binning.tcl
    source SiD_params/SiD_BeamCal_EnergyFractions.tcl
    source SiD_params/SiD_BeamCal_Resolution.tcl
}





#############
#   HCAL
#############

module SimpleCalorimeter HCal {
  set ParticleInputArray ParticlePropagator/stableParticles
  #Jim: change 
  set TrackInputArray ECal/eflowTracks
  #set TrackInputArray TrackMerger/tracks

  set TowerOutputArray hcalTowers
  set EFlowTrackOutputArray eflowTracks

  set EFlowTowerOutputArray eflowNeutralHadrons

  set IsEcal false
  set EnergyMin 1.0
  set EnergySignificanceMin 1.0
  set SmearTowerCenter true


  source SiD_params/SiD_HCal_Binning.tcl

  source SiD_params/SiD_HCal_EnergyFractions.tcl

  source SiD_params/SiD_HCal_Resolution.tcl
                 
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


############################
# Jim: Energy flow track merger
############################

module Merger EFlowTrackMerger {
# add InputArray InputArray
  #add InputArray ECal/eflowTracks #Jim test: comment this out
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
  add InputArray LumiCalF/eflowPhotons
  add InputArray LumiCalR/eflowPhotons
  #add InputArray HCal/eflowNeutralHadrons
  add InputArray TimeOfFlightNeutralHadron/eflowNeutralHadrons
  set OutputArray eflow
}



###################
# Photon efficiency
###################

module Efficiency PhotonEfficiency {
  set InputArray ECal/eflowPhotons
  set OutputArray photons

  source SiD_params/SiD_PhotonEfficiency.tcl

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
  set PTRatioMax 9999. 
#Jim
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




###################################################
# Tower Merger (in case not using e-flow algorithm)
###################################################

module Merger TowerMerger {
# add InputArray InputArray
  add InputArray ECal/ecalTowers
  add InputArray HCal/hcalTowers
  add InputArray LumiCalF/lumicalTowers
  add InputArray LumiCalR/lumicalTowers
  #Jim
 # add InputArray MuonFilter/muons #Jim: comment out
  set OutputArray towers
}



###############################
# BeamCal tower merger
###############################
module Merger BCalTowerMerger {
# add InputArray InputArray
  add InputArray BeamCalF/bcalTowers
  add InputArray BeamCalR/bcalTowers
  set OutputArray bcalTowers
}
  
###############################
# BeamCal energy flow merger
###############################
module Merger BCalEFlowMerger {
# add InputArray InputArray
  add InputArray BeamCalF/bcalPhotons
  add InputArray BeamCalR/bcalPhotons
  set OutputArray bcalPhotons
}
  
##############################
# BeamCal photon efficiency
##############################
module Efficiency BCalEfficiency {
    set InputArray  BCalEFlowMerger/bcalPhotons
    set OutputArray bcalPhotons
    source SiD_params/SiD_BeamCal_Efficiency.tcl
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


#####################
# Electron efficiency
#####################

module Efficiency ElectronEfficiency {
  set InputArray ElectronFilter/electrons
  set OutputArray electrons
  source SiD_params/SiD_ElectronEfficiency.tcl

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
  set PTRatioMax 9999. 
#Jim
}



#################
# Muon efficiency
#################

module Efficiency MuonEfficiency {
  set InputArray MuonFilter/muons
  set OutputArray muons

  source SiD_params/SiD_MuonEfficiency.tcl

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
  set PTRatioMax  9999. 
#Jim
}


###################
# Missing ET merger
###################

module Merger MissingET {
# add InputArray InputArray
  add InputArray EFlowMerger/eflow
  set MomentumOutputArray momentum
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


#########################
# Gen Missing ET merger
########################

module Merger GenMissingET {
# add InputArray InputArray
  add InputArray NeutrinoFilter/filteredParticles
  set MomentumOutputArray momentum
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






##################
# Scalar HT merger
##################

module Merger ScalarHT {
# add InputArray InputArray
  add InputArray EFlowMerger/eflow
  set EnergyOutputArray energy
}





#####################################################
# Find uniquely identified photons/electrons/tau/jets
#####################################################

module UniqueObjectFinder UniqueObjectFinder {
# earlier arrays take precedence over later ones
# add InputArray InputArray OutputArray
  #add InputArray PhotonIsolation/photons photons
  #add InputArray ElectronIsolation/electrons electrons
  #add InputArray MuonIsolation/muons muons
  # ---- Jim; the above is if you want isolation. Without isolation:
  add InputArray PhotonEfficiency/photons photons
  add InputArray ElectronEfficiency/electrons electrons
  add InputArray MuonEfficiency/muons muons
  
  
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

  # BeamCal photons - not included in particle flow/clustering
  #  nor in the transverse momentym/energy calculation
  
  add Branch BCalEfficiency/bcalPhotons BCalPhoton Photon

 # add Branch ChargedHadronMomentumSmearing/chargedHadrons ChargedHadron Track
  #add Branch HCal/eflowNeutralHadrons EFlowNeutralHadron Tower 
  # Jim: change from NeutralHadron to EFlowNeutralHadron
  #add Branch ScalarHT/energy ScalarHT ScalarHT

  # add Info InfoName InfoValue
  add Info Bz $B

}


