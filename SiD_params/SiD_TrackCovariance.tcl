## minimum number of hits to accept a track
set NMinHits 6


## scale factors
set ElectronScaleFactor  {1.25} 
#Jim: why?

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
  1 PIPE -100 100 0.012 0.0004 0.35276 0 0 0 0 0 0
  1 VTX -0.063 0.063 0.014 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  1 VTX -0.063 0.063 0.022 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  1 VTX -0.063 0.063 0.035 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  1 VTX -0.063 0.063 0.048 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  1 VTX -0.063 0.063 0.06 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  1 VTX -0.063 0.063 0.01405 4.37e-05 0.0937 0 0 0 0 0 0
  1 VTX -0.063 0.063 0.02205 4.37e-05 0.0937 0 0 0 0 0 0
  1 VTX -0.063 0.063 0.03505 4.37e-05 0.0937 0 0 0 0 0 0
  1 VTX -0.063 0.063 0.04805 4.37e-05 0.0937 0 0 0 0 0 0
  1 VTX -0.063 0.063 0.06005 4.37e-05 0.0937 0 0 0 0 0 0
  1 VTX -0.882 0.882 0.166 0.00026 0.1932 0 0 0 0 0 0
  1 VTX -0.897 0.897 0.181 0.00026 0.1932 0 0 0 0 0 0
  1 TRK -0.558 0.558 0.2195 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  1 TRK -0.7365 0.7365 0.4695 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  1 TRK -1.0005 1.0005 0.7195 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  1 TRK -1.259 1.259 0.9695 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  1 TRK -1.5225 1.5225 1.2195 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  1 TRK -0.558 0.558 0.2196 0.000181 0.0937 0 0 0 0 0 0
  1 TRK -0.7365 0.7365 0.4696 0.000181 0.0937 0 0 0 0 0 0
  1 TRK -1.0005 1.0005 0.7196 0.000181 0.0937 0 0 0 0 0 0
  1 TRK -1.259 1.259 0.9696 0.000181 0.0937 0 0 0 0 0 0
  1 TRK -1.5225 1.5225 1.2196 0.000181 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.02 0.071 -0.172 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.018 0.071 -0.123 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.016 0.071 -0.092 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.014 0.071 -0.072 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.014 0.071 0.072 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.016 0.071 0.092 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.018 0.071 0.123 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.02 0.071 0.172 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK 0.02 0.071 -0.17205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.018 0.071 -0.12305 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.016 0.071 -0.09205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.014 0.071 -0.07205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.014 0.071 0.07205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.016 0.071 0.09205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.018 0.071 0.12305 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK 0.02 0.071 0.17205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.117 0.166 -0.832 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.076 0.166 -0.541 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.028 0.166 -0.207 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.028 0.166 0.207 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.076 0.166 0.541 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.117 0.166 0.832 5e-05 0.0937 2 0 1.5708 3e-06 3e-06 1
  2 VTXDSK_FWD 0.091 0.166 -0.897 0.00026 0.1932 0 0 0 0 0 0
  2 VTXDSK_FWD 0.091 0.166 -0.882 0.00026 0.1932 0 0 0 0 0 0
  2 VTXDSK_FWD 0.117 0.166 -0.83205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.076 0.166 -0.54105 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.028 0.166 -0.20705 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.028 0.166 0.20705 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.076 0.166 0.54105 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.117 0.166 0.83205 4.37e-05 0.0937 0 0 0 0 0 0
  2 VTXDSK_FWD 0.091 0.166 0.882 0.00026 0.1932 0 0 0 0 0 0
  2 VTXDSK_FWD 0.091 0.166 0.897 0.00026 0.1932 0 0 0 0 0 0
  2 TRKDSK 0.2089 1.2536 -1.6409 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 1.0031 -1.3555 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 0.7514 -1.075 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 0.498 -0.7889 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 0.498 0.7889 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 0.7514 1.075 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 1.0031 1.3555 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 1.2536 1.6409 0.0001 0.0937 2 0 1.5708 7e-06 7e-06 1
  2 TRKDSK 0.2089 1.2536 -1.641 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 1.0031 -1.3556 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 0.7514 -1.0751 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 0.498 -0.789 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 0.498 0.789 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 0.7514 1.0751 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 1.0031 1.3556 0.000181 0.0937 0 0 0 0 0 0
  2 TRKDSK 0.2089 1.2536 1.641 0.000181 0.0937 0 0 0 0 0 0
  1 MAG -2.793 2.793 2.731 0.38 0.0658 0 0 0 0 0 0


}
