'# MWS Version: Version 2021.1 - Nov 10 2020 - ACIS 30.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 4 fmax = 12
'# created = '[VERSION]2021.1|30.0.1|20201110[/VERSION]


'@ use template: FSS, Metamaterial - Unit Cell_8.cfg

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
'set the units
With Units
    .Geometry "mm"
    .Frequency "GHz"
    .Voltage "V"
    .Resistance "Ohm"
    .Inductance "H"
    .TemperatureUnit  "Kelvin"
    .Time "ns"
    .Current "A"
    .Conductance "Siemens"
    .Capacitance "F"
End With

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "4", "12"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .Rho "1.204"
     .ThermalType "Normal"
     .ThermalConductivity "0.026"
      .SpecificHeat "1005", "J/K/kg"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

' define Floquet port boundaries

With FloquetPort
     .Reset
     .SetDialogTheta "0"
     .SetDialogPhi "0"
     .SetSortCode "+beta/pw"
     .SetCustomizedListFlag "False"
     .Port "Zmin"
     .SetNumberOfModesConsidered "2"
     .Port "Zmax"
     .SetNumberOfModesConsidered "2"
End With

MakeSureParameterExists "theta", "0"
SetParameterDescription "theta", "spherical angle of incident plane wave"
MakeSureParameterExists "phi", "0"
SetParameterDescription "phi", "spherical angle of incident plane wave"

' define boundaries, the open boundaries define floquet port

With Boundary
     .Xmin "unit cell"
     .Xmax "unit cell"
     .Ymin "unit cell"
     .Ymax "unit cell"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .XPeriodicShift "0.0"
     .YPeriodicShift "0.0"
     .ZPeriodicShift "0.0"
     .PeriodicUseConstantAngles "False"
     .SetPeriodicBoundaryAngles "theta", "phi"
     .SetPeriodicBoundaryAnglesDirection "inward"
     .UnitCellFitToBoundingBox "True"
     .UnitCellDs1 "0.0"
     .UnitCellDs2 "0.0"
     .UnitCellAngle "90.0"
End With

' set tet mesh as default

With Mesh
     .MeshType "Tetrahedral"
End With

' FD solver excitation with incoming plane wave at Zmax

With FDSolver
     .Reset
     .Stimulation "List", "List"
     .ResetExcitationList
     .AddToExcitationList "Zmax", "TE(0,0);TM(0,0)"
     .LowFrequencyStabilization "False"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "4;8;12"
Dim sDefineAtName As String
sDefineAtName = "4;8;12"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Tet"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "Tetrahedral"
End With

'set the solver type
ChangeSolverType("HF Frequency Domain")

'----------------------------------------------------------------------------

'@ paste structure data: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Material 
     .Reset 
     .Name "Copper (annealed)_1" 
     .Folder "" 
     .Rho "8930.0"
     .ThermalType "Normal"
     .ThermalConductivity "401.0"
     .SpecificHeat "390", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0"
     .VoxelConvection "0"
     .BloodFlow "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "120"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "17"
     .FrqType "static"
     .Type "Normal"
     .MaterialUnit "Frequency", "Hz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "1"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps  "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "Nth Order"
     .MaximalOrderNthModelFitEps "10"
     .ErrorLimitNthModelFitEps "0.1"
     .UseOnlyDataInSimFreqRangeNthModelEps "False"
     .DispersiveFittingSchemeMu "Nth Order"
     .MaximalOrderNthModelFitMu "10"
     .ErrorLimitNthModelFitMu "0.1"
     .UseOnlyDataInSimFreqRangeNthModelMu "False"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Mu "1.0"
     .Sigma "5.8e+007"
     .LossyMetalSIRoughness "0.0"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With Material 
     .Reset 
     .Name "FR-4 (lossy)" 
     .Folder "" 
     .Rho "0.0"
     .ThermalType "Normal"
     .ThermalConductivity "0.3"
     .SpecificHeat "0", "J/K/kg"
     .DynamicViscosity "0"
     .Emissivity "0"
     .MetabolicRate "0.0"
     .VoxelConvection "0.0"
     .BloodFlow "0"
     .MechanicsType "Unused"
     .FrqType "all"
     .Type "Normal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .Epsilon "4.3"
     .Mu "1.0"
     .Sigma "0.0"
     .TanD "0.025"
     .TanDFreq "10.0"
     .TanDGiven "True"
     .TanDModel "ConstTanD"
     .SetConstTanDStrategyEps "AutomaticOrder"
     .ConstTanDModelOrderEps "3"
     .DjordjevicSarkarUpperFreqEps "0"
     .SetElParametricConductivity "False"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .SigmaM "0.0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstSigma"
     .SetConstTanDStrategyMu "AutomaticOrder"
     .ConstTanDModelOrderMu "3"
     .DjordjevicSarkarUpperFreqMu "0"
     .SetMagParametricConductivity "False"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "1st Order"
     .DispersiveFittingSchemeMu "1st Order"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "0.94", "0.82", "0.76" 
     .Wireframe "False" 
     .Reflection "False" 
     .Allowoutline "True" 
     .Transparentoutline "False" 
     .Transparency "0" 
     .Create
End With 

With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ define port: 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .PortNumber "1" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "-9.4035143125+0.035"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Full"
     .Orientation "zmax"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "-4.5", "4.5"
     .Yrange "-4.5", "4.5"
     .Zrange "9.4035143125", "9.4035143125"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define port: 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Port 
     .Reset 
     .PortNumber "2" 
     .Label ""
     .Folder ""
     .NumberOfModes "1"
     .AdjustPolarization "False"
     .PolarizationAngle "0.0"
     .ReferencePlaneDistance "-10.9685143125+1.6"
     .TextSize "50"
     .TextMaxLimit "1"
     .Coordinates "Full"
     .Orientation "zmin"
     .PortOnBound "True"
     .ClipPickedPortToBound "False"
     .Xrange "-4.5", "4.5"
     .Yrange "-4.5", "4.5"
     .Zrange "-10.9685143125", "-10.9685143125"
     .XrangeAdd "0.0", "0.0"
     .YrangeAdd "0.0", "0.0"
     .ZrangeAdd "0.0", "0.0"
     .SingleEnded "False"
     .WaveguideMonitor "False"
     .Create 
End With

'@ define boundaries

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Boundary
     .Xmin "electric"
     .Xmax "electric"
     .Ymin "magnetic"
     .Ymax "magnetic"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
     .ApplyInAllDirections "False"
     .OpenAddSpaceFactor "0.5"
End With

'@ define frequency domain solver parameters

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Mesh.SetCreator "High Frequency" 

With FDSolver
     .Reset 
     .SetMethod "Tetrahedral", "General purpose" 
     .OrderTet "Second" 
     .OrderSrf "First" 
     .Stimulation "All", "1" 
     .ResetExcitationList 
     .AutoNormImpedance "False" 
     .NormingImpedance "50" 
     .ModesOnly "False" 
     .ConsiderPortLossesTet "True" 
     .SetShieldAllPorts "False" 
     .AccuracyHex "1e-6" 
     .AccuracyTet "1e-4" 
     .AccuracySrf "1e-3" 
     .LimitIterations "False" 
     .MaxIterations "0" 
     .SetCalcBlockExcitationsInParallel "True", "True", "" 
     .StoreAllResults "False" 
     .StoreResultsInCache "False" 
     .UseHelmholtzEquation "True" 
     .LowFrequencyStabilization "False" 
     .Type "Auto" 
     .MeshAdaptionHex "False" 
     .MeshAdaptionTet "True" 
     .AcceleratedRestart "True" 
     .FreqDistAdaptMode "Distributed" 
     .NewIterativeSolver "True" 
     .TDCompatibleMaterials "False" 
     .ExtrudeOpenBC "False" 
     .SetOpenBCTypeHex "Default" 
     .SetOpenBCTypeTet "Default" 
     .AddMonitorSamples "True" 
     .CalcPowerLoss "True" 
     .CalcPowerLossPerComponent "False" 
     .StoreSolutionCoefficients "True" 
     .UseDoublePrecision "False" 
     .UseDoublePrecision_ML "True" 
     .MixedOrderSrf "False" 
     .MixedOrderTet "False" 
     .PreconditionerAccuracyIntEq "0.15" 
     .MLFMMAccuracy "Default" 
     .MinMLFMMBoxSize "0.3" 
     .UseCFIEForCPECIntEq "True" 
     .UseFastRCSSweepIntEq "false" 
     .UseSensitivityAnalysis "False" 
     .RemoveAllStopCriteria "Hex"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Hex", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Hex", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Hex", "False"
     .RemoveAllStopCriteria "Tet"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Tet", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Tet", "False"
     .AddStopCriterion "All Probes", "0.05", "2", "Tet", "True"
     .RemoveAllStopCriteria "Srf"
     .AddStopCriterion "All S-Parameters", "0.01", "2", "Srf", "True"
     .AddStopCriterion "Reflection S-Parameters", "0.01", "2", "Srf", "False"
     .AddStopCriterion "Transmission S-Parameters", "0.01", "2", "Srf", "False"
     .SweepMinimumSamples "3" 
     .SetNumberOfResultDataSamples "1001" 
     .SetResultDataSamplingMode "Automatic" 
     .SweepWeightEvanescent "1.0" 
     .AccuracyROM "1e-4" 
     .AddSampleInterval "", "", "1", "Automatic", "True" 
     .AddSampleInterval "", "", "", "Automatic", "False" 
     .MPIParallelization "False"
     .UseDistributedComputing "False"
     .NetworkComputingStrategy "RunRemote"
     .NetworkComputingJobCount "3"
     .UseParallelization "True"
     .MaxCPUs "1024"
     .MaximumNumberOfCPUDevices "2"
End With

With IESolver
     .Reset 
     .UseFastFrequencySweep "True" 
     .UseIEGroundPlane "False" 
     .SetRealGroundMaterialName "" 
     .CalcFarFieldInRealGround "False" 
     .RealGroundModelType "Auto" 
     .PreconditionerType "Auto" 
     .ExtendThinWireModelByWireNubs "False" 
     .ExtraPreconditioning "False" 
End With

With IESolver
     .SetFMMFFCalcStopLevel "0" 
     .SetFMMFFCalcNumInterpPoints "6" 
     .UseFMMFarfieldCalc "True" 
     .SetCFIEAlpha "0.500000" 
     .LowFrequencyStabilization "False" 
     .LowFrequencyStabilizationML "True" 
     .Multilayer "False" 
     .SetiMoMACC_I "0.0001" 
     .SetiMoMACC_M "0.0001" 
     .DeembedExternalPorts "True" 
     .SetOpenBC_XY "True" 
     .OldRCSSweepDefintion "False" 
     .SetRCSOptimizationProperties "True", "100", "0.00001" 
     .SetAccuracySetting "Custom" 
     .CalculateSParaforFieldsources "True" 
     .ModeTrackingCMA "True" 
     .NumberOfModesCMA "3" 
     .StartFrequencyCMA "-1.0" 
     .SetAccuracySettingCMA "Default" 
     .FrequencySamplesCMA "0" 
     .SetMemSettingCMA "Auto" 
     .CalculateModalWeightingCoefficientsCMA "True" 
End With

'@ split shape: component1:solid2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.SplitShape "solid2", "component1"

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:solid8_1" 
Solid.Delete "component1:solid8_1_1" 
Solid.Delete "component1:solid8_1_1_1" 
Solid.Delete "component1:solid8_1_2" 
Solid.Delete "component1:solid8_1_2_1" 
Solid.Delete "component1:solid8_1_3" 
Solid.Delete "component1:solid9" 
Solid.Delete "component1:solid9_1"

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-0.24", "0.04" 
     .Yrange "0.3", "0.45" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-0.24", "0.04" 
     .Yrange "0.3", "0.45" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid12, component1:solid2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid12", "component1:solid2"

'@ define monitor: h-field (f=5.624)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.624)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.624" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=5.888)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.888)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.888" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=9.976)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=9.976)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "9.976" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: e-field (f=11.536)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=11.536)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "11.536" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=11.536)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=11.536)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "11.536" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ change material: component1:solid11 to: Copper (annealed)_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeMaterial "component1:solid11", "Copper (annealed)_1"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "46", "35"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "0"
    .SetOrientation "Smart Mode"
    .SetDistance "0.298721"
    .SetViewVector "0.000000", "-0.000010", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid7", "46", "35"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "1"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.014233"
    .SetViewVector "0.000000", "-0.000010", "-1.000000"
    .SetConnectedElement1 "component1:solid7"
    .SetConnectedElement2 "component1:solid7"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid2_4", "612", "461"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "2"
    .SetOrientation "Smart Mode"
    .SetDistance "0.043180"
    .SetViewVector "0.000000", "-0.000010", "-1.000000"
    .SetConnectedElement1 "component1:solid2_4"
    .SetConnectedElement2 "component1:solid2_4"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid2_1", "774", "583"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "3"
    .SetOrientation "Smart Mode"
    .SetDistance "0.778817"
    .SetViewVector "0.000000", "-0.000006", "-1.000000"
    .SetConnectedElement1 "component1:solid2_1"
    .SetConnectedElement2 "component1:solid2_1"
    .Create
End With

Pick.ClearAllPicks

'@ split shape: component1:solid10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.SplitShape "solid10", "component1"

'@ define brick: component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.66", "-2.62" 
     .Yrange "2.6", "2.64" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid14" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.5", "-2.18" 
     .Yrange "2.6", "2.64" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid13"

'@ boolean add shapes: component1:solid10, component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid14"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "70", "9"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "4"
    .SetOrientation "Smart Mode"
    .SetDistance "0.283634"
    .SetViewVector "-0.013962", "0.010469", "-0.999848"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.66", "-2.62" 
     .Yrange "2.6", "2.62" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid10, component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid13"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "100", "70"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "5"
    .SetOrientation "Smart Mode"
    .SetDistance "0.029963"
    .SetViewVector "-0.013962", "0.010470", "-0.999848"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "100", "70"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "6"
    .SetOrientation "Smart Mode"
    .SetDistance "0.194884"
    .SetViewVector "-0.013962", "0.010470", "-0.999848"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.5", "-2.18" 
     .Yrange "2.6", "2.62" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid10, component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid13"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "98", "71"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "7"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.055287"
    .SetViewVector "-0.020942", "0.010469", "-0.999726"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ delete shape: component1:solid10_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:solid10_1"

'@ transform: mirror component1:solid10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid2_1", "774", "583"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "8"
    .SetOrientation "Smart Mode"
    .SetDistance "0.915280"
    .SetViewVector "-0.020942", "0.010466", "-0.999726"
    .SetConnectedElement1 "component1:solid2_1"
    .SetConnectedElement2 "component1:solid2_1"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid13" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-3.34", "-2.85" 
     .Yrange "0.08", "0.14" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid14" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-3.34", "-3.25" 
     .Yrange "-0.14", "0.08" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid15

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid15" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.54", "2.9" 
     .Yrange "0.08", "0.14" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid16

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid16" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-3.25", "2.9" 
     .Yrange "-0.15", "-0.1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid13, component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid13", "component1:solid14"

'@ boolean add shapes: component1:solid15, component1:solid16

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid15", "component1:solid16"

'@ boolean add shapes: component1:solid15, component1:solid2_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid15", "component1:solid2_1"

'@ boolean add shapes: component1:solid13, component1:solid15

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid13", "component1:solid15"

'@ boolean add shapes: component1:solid11, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid11", "component1:solid12"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "112", "78"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "9"
    .SetOrientation "Smart Mode"
    .SetDistance "0.251399"
    .SetViewVector "-0.024432", "0.006976", "-0.999677"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ delete monitor: h-field (f=11.536)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Delete "h-field (f=11.536)" 
End With

'@ define monitor: h-field (f=11.52)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=11.52)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "11.52" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6000000000000001", "0.035000000000000003" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: h-field (f=11.52)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Delete "h-field (f=11.52)" 
End With

'@ define monitor: h-field (f=5.896)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.896)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.896" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6000000000000001", "0.035000000000000003" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid13", "827", "618"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "10"
    .SetOrientation "Smart Mode"
    .SetDistance "0.769851"
    .SetViewVector "0.000000", "-0.000009", "-1.000000"
    .SetConnectedElement1 "component1:solid13"
    .SetConnectedElement2 "component1:solid13"
    .Create
End With

Pick.ClearAllPicks

'@ new component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component2"

'@ delete component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.Delete "component2"

'@ define brick: component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid14" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-3.25", "-2.85" 
     .Yrange "0.08", "0.1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid13, component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid13", "component1:solid14"

'@ define brick: component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid14" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.54", "2.88" 
     .Yrange "0.08", "0.1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid13, component1:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid13", "component1:solid14"

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid13", "802", "603"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "11"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.068537"
    .SetViewVector "-0.003491", "-0.003494", "-0.999988"
    .SetConnectedElement1 "component1:solid13"
    .SetConnectedElement2 "component1:solid13"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid13", "869", "647"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "12"
    .SetOrientation "Smart Mode"
    .SetDistance "0.035005"
    .SetViewVector "-0.003491", "-0.003494", "-0.999988"
    .SetConnectedElement1 "component1:solid13"
    .SetConnectedElement2 "component1:solid13"
    .Create
End With

Pick.ClearAllPicks

'@ define monitor: e-field (f=5.672)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=5.672)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "5.672" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: e-field (f=5.912)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=5.912)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "5.912" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: e-field (f=9.992)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "e-field (f=9.992)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Efield" 
     .MonitorValue "9.992" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=11.56)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=11.56)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "11.56" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=5.672)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Delete "e-field (f=5.672)" 
End With

'@ define monitor: h-field (f=5.672)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.672)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.672" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6000000000000001", "0.035000000000000003" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=9.992)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Delete "e-field (f=9.992)" 
End With

'@ define monitor: h-field (f=9.992)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=9.992)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "9.992" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6000000000000001", "0.035000000000000003" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ delete monitor: e-field (f=5.912)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Delete "e-field (f=5.912)" 
End With

'@ define monitor: h-field (f=5.912)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.912)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.912" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6000000000000001", "0.035000000000000003" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=5.664)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.664)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.664" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=5.912)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=5.912)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "5.912" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=9.992)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=9.992)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "9.992" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=11.544)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=11.544)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "11.544" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ define monitor: h-field (f=4.488)

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Monitor 
     .Reset 
     .Name "h-field (f=4.488)" 
     .Dimension "Volume" 
     .Domain "Frequency" 
     .FieldType "Hfield" 
     .MonitorValue "4.488" 
     .UseSubvolume "False" 
     .Coordinates "Structure" 
     .SetSubvolume "-4.5", "4.5", "-4.5", "4.5", "-1.6", "0.035" 
     .SetSubvolumeOffset "0.0", "0.0", "0.0", "0.0", "0.0", "0.0" 
     .SetSubvolumeInflateWithOffset "False" 
     .Create 
End With

'@ switch working plane

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Plot.DrawWorkplane "false"

'@ new component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.New "component2"

'@ define brick: component2:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid14" 
     .Component "component2" 
     .Material "Copper (annealed)_1" 
     .Xrange "3", "3.2" 
     .Yrange "3.18", "3.38" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid10_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid10_1"

'@ boolean add shapes: component1:solid11, component1:solid13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid11", "component1:solid13"

'@ delete dimension 10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "10"
End With

'@ delete dimension 11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "11"
End With

'@ delete dimension 12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "12"
End With

'@ boolean add shapes: component1:solid2_2, component1:solid2_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid2_2", "component1:solid2_3"

'@ boolean add shapes: component1:solid2_4, component1:solid2_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid2_4", "component1:solid2_5"

'@ boolean add shapes: component1:solid5, component1:solid5_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid5", "component1:solid5_1"

'@ boolean add shapes: component1:solid6, component1:solid6_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid6", "component1:solid6_1"

'@ boolean add shapes: component1:solid6, component1:solid7

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid6", "component1:solid7"

'@ delete dimension 1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "1"
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ boolean add shapes: component1:solid2_2, component1:solid2_4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid2_2", "component1:solid2_4"

'@ delete dimension 2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "2"
End With

'@ boolean add shapes: component1:solid5, component1:solid6

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid5", "component1:solid6"

'@ boolean add shapes: component1:solid10, component1:solid2_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid2_2"

'@ boolean add shapes: component1:solid10, component1:solid5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid5"

'@ transform: mirror component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component2" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean add shapes: component1:solid10, component2:solid14

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component2:solid14"

'@ boolean add shapes: component1:solid10, component2:solid14_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component2:solid14_1"

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "3", "3.2" 
     .Yrange "-3.24", "-3.08" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3480"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3475"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "13"
    .SetOrientation "Smart Mode"
    .SetDistance "0.118473"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "3", "3.2" 
     .Yrange "1.9", "2.15" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "3", "3.2" 
     .Yrange "1.95", "2.1" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid11, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid11", "component1:solid12"

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "22"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "18"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "14"
    .SetOrientation "Smart Mode"
    .SetDistance "0.076077"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3544"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3539"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "15"
    .SetOrientation "Smart Mode"
    .SetDistance "0.114527"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "3", "3.2" 
     .Yrange "-2.5", "-1.9" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "3", "3.2" 
     .Yrange "-2.15", "-2.00" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ boolean subtract shapes: component1:solid10, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid12"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3776"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3771"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "16"
    .SetOrientation "Smart Mode"
    .SetDistance "0.058020"
    .SetViewVector "0.000000", "-0.000002", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "458"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "463"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "17"
    .SetOrientation "Smart Mode"
    .SetDistance "0.172427"
    .SetViewVector "0.000000", "-0.000002", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.85", "-2.8" 
     .Yrange "3.15", "3.35" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "466"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "18"
    .SetOrientation "Smart Mode"
    .SetDistance "0.109245"
    .SetViewVector "-0.000000", "-0.000002", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3759"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3764"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "19"
    .SetOrientation "Smart Mode"
    .SetDistance "0.042984"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.66", "-2.62" 
     .Yrange "2.62", "2.72" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3752"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3751"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "20"
    .SetOrientation "Smart Mode"
    .SetDistance "0.060055"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "5130", "3794"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "21"
    .SetOrientation "Smart Mode"
    .SetDistance "0.043747"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3794"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3772"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "22"
    .SetOrientation "Smart Mode"
    .SetDistance "0.015206"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.51", "-2.5" 
     .Yrange "2.62", "2.72" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ change material: component1:solid11 to: Copper (annealed)_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeMaterial "component1:solid11", "Copper (annealed)_1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3794"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "23"
    .SetOrientation "Smart Mode"
    .SetDistance "0.036175"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid11"
    .Create
End With

Pick.ClearAllPicks

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ delete dimension 23

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "23"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3802"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "24"
    .SetOrientation "Smart Mode"
    .SetDistance "0.032098"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "322"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "327"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "25"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.066503"
    .SetViewVector "-0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2", "-1.95" 
     .Yrange "1.75", "1.9" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ boolean subtract shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "331"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3812"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "26"
    .SetOrientation "Smart Mode"
    .SetDistance "0.048750"
    .SetViewVector "-0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Vacuum" 
     .Xrange "-2.2", "-2.10" 
     .Yrange "1.75", "1.9" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ change material: component1:solid11 to: Copper (annealed)_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.ChangeMaterial "component1:solid11", "Copper (annealed)_1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3812"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "1"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "27"
    .SetOrientation "Smart Mode"
    .SetDistance "0.026144"
    .SetViewVector "-0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid11"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3812"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "28"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.002030"
    .SetViewVector "-0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid11"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ delete dimension 27

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "27"
End With

'@ delete dimension 28

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "28"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1902"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1907"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "29"
    .SetOrientation "Smart Mode"
    .SetDistance "0.105013"
    .SetViewVector "0.000000", "-0.000003", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-0", "0.08" 
     .Yrange "2.4", "2.55" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1906"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "30"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.025980"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid11"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ delete dimension 30

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "30"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1914"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "31"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.037947"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "2"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1915"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "32"
    .SetOrientation "Smart Mode"
    .SetDistance "0.054717"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "146"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "151"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "33"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.094490"
    .SetViewVector "-0.000000", "-0.000002", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "1.8", "1.85" 
     .Yrange "1.8", "1.9" 
     .Zrange "0", "0.035" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "2"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "151"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "34"
    .SetOrientation "Smart Mode"
    .SetDistance "0.050531"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid11"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ delete dimension 34

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "34"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "2"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "159"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "35"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.053282"
    .SetViewVector "0.000000", "-0.000001", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3651"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3656"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "36"
    .SetOrientation "Smart Mode"
    .SetDistance "0.078268"
    .SetViewVector "-0.006981", "-0.000003", "-0.999976"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.03", "-1.82" 
     .Yrange "1.15", "1.3" 
     .Zrange "0", "pt" 
     .Create
End With

'@ delete component: component2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Component.Delete "component2"

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2", "-1.85" 
     .Yrange "1.15", "1.3" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "3"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "37"
    .SetOrientation "Smart Mode"
    .SetDistance "0.037751"
    .SetViewVector "-0.013962", "0.010470", "-0.999848"
    .SetConnectedElement1 "component1:solid12"
    .SetConnectedElement2 "component1:solid12"
    .Create
End With

Pick.ClearAllPicks

'@ boolean subtract shapes: component1:solid11, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid11", "component1:solid12"

'@ delete dimension 37

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "37"
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "18"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "22"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "38"
    .SetOrientation "Smart Mode"
    .SetDistance "0.043548"
    .SetViewVector "-0.013962", "0.010470", "-0.999848"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2", "-1.83" 
     .Yrange "0.95", "1.05" 
     .Zrange "0", "pt" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2", "-1.85" 
     .Yrange "0.95", "1.05" 
     .Zrange "0", "pt" 
     .Create
End With

'@ boolean subtract shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid11"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3879"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3884"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "39"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.158749"
    .SetViewVector "-0.013961", "0.013960", "-0.999805"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3046"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3051"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "40"
    .SetOrientation "Smart Mode"
    .SetDistance "0.134398"
    .SetViewVector "-0.013961", "0.013960", "-0.999805"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.85", "-2.54" 
     .Yrange "0.1", "0.2" 
     .Zrange "0", "pt" 
     .Create
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.78", "-2.63" 
     .Yrange "0.1", "0.2" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "3"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid11", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "41"
    .SetOrientation "Smart Mode"
    .SetDistance "0.038426"
    .SetViewVector "-0.017451", "0.017451", "-0.999695"
    .SetConnectedElement1 "component1:solid11"
    .SetConnectedElement2 "component1:solid11"
    .Create
End With

Pick.ClearAllPicks

'@ boolean subtract shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid11"

'@ delete dimension 41

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "41"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3903"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3908"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "42"
    .SetOrientation "Smart Mode"
    .SetDistance "0.056787"
    .SetViewVector "-0.017451", "0.017451", "-0.999695"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-0.24", "0.05" 
     .Yrange "-0.45", "-0.32" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid11", "2", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "43"
    .SetOrientation "Smart Mode"
    .SetDistance "0.102848"
    .SetViewVector "-0.017451", "0.017450", "-0.999695"
    .SetConnectedElement1 "component1:solid11"
    .SetConnectedElement2 "component1:solid11"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-0.16", "-0.015" 
     .Yrange "-0.45", "-0.32" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "3"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "44"
    .SetOrientation "Smart Mode"
    .SetDistance "0.053849"
    .SetViewVector "-0.017451", "0.017451", "-0.999695"
    .SetConnectedElement1 "component1:solid12"
    .SetConnectedElement2 "component1:solid12"
    .Create
End With

Pick.ClearAllPicks

'@ boolean subtract shapes: component1:solid11, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid11", "component1:solid12"

'@ delete dimension 44

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "44"
End With

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ delete dimension 43

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "43"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "18"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "22"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "45"
    .SetOrientation "Smart Mode"
    .SetDistance "0.056055"
    .SetViewVector "-0.024431", "0.017449", "-0.999549"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid11" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-2.005", "-1.825" 
     .Yrange "-1.05", "-0.95" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1054"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1059"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "46"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.104295"
    .SetViewVector "-0.024431", "0.017450", "-0.999549"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ define brick: component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Brick
     .Reset 
     .Name "solid12" 
     .Component "component1" 
     .Material "Copper (annealed)_1" 
     .Xrange "-1.99", "-1.84" 
     .Yrange "-1.05", "-0.95" 
     .Zrange "0", "pt" 
     .Create
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "3"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid12", "2"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "47"
    .SetOrientation "Smart Mode"
    .SetDistance "0.075910"
    .SetViewVector "-0.024431", "0.017450", "-0.999549"
    .SetConnectedElement1 "component1:solid12"
    .SetConnectedElement2 "component1:solid12"
    .Create
End With

Pick.ClearAllPicks

'@ boolean add shapes: component1:solid10, component1:solid11

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid11"

'@ boolean subtract shapes: component1:solid10, component1:solid12

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Subtract "component1:solid10", "component1:solid12"

'@ delete dimension 47

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .RemoveDimension "47"
End With

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3951"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3956"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "48"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.080719"
    .SetViewVector "-0.024431", "0.017450", "-0.999549"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ split shape: component1:solid10

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.SplitShape "solid10", "component1"

'@ delete shapes

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Delete "component1:solid10_10" 
Solid.Delete "component1:solid10_11" 
Solid.Delete "component1:solid10_12" 
Solid.Delete "component1:solid10_6" 
Solid.Delete "component1:solid10_7"

'@ transform: mirror component1:solid10_4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10_4" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:solid10_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10_3" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:solid10_9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10_9" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:solid10_8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10_8" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "True" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ transform: mirror component1:solid10_13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid10_13" 
     .Origin "Free" 
     .Center "0", "0", "0" 
     .PlaneNormal "0", "1", "0" 
     .MultipleObjects "True" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .Destination "" 
     .Material "" 
     .Transform "Shape", "Mirror" 
End With

'@ boolean add shapes: component1:solid10, component1:solid10_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid10_1"

'@ boolean add shapes: component1:solid10_13, component1:solid10_13_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_13", "component1:solid10_13_1"

'@ boolean add shapes: component1:solid10_2, component1:solid10_3

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_2", "component1:solid10_3"

'@ boolean add shapes: component1:solid10_3_1, component1:solid10_4

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_3_1", "component1:solid10_4"

'@ boolean add shapes: component1:solid10_4_1, component1:solid10_5

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_4_1", "component1:solid10_5"

'@ boolean add shapes: component1:solid10_8, component1:solid10_8_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_8", "component1:solid10_8_1"

'@ boolean add shapes: component1:solid10_9, component1:solid10_9_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_9", "component1:solid10_9_1"

'@ boolean add shapes: component1:solid10, component1:solid10_13

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid10_13"

'@ boolean add shapes: component1:solid10_2, component1:solid10_3_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_2", "component1:solid10_3_1"

'@ boolean add shapes: component1:solid10_4_1, component1:solid10_8

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_4_1", "component1:solid10_8"

'@ boolean add shapes: component1:solid10_4_1, component1:solid10_9

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10_4_1", "component1:solid10_9"

'@ boolean add shapes: component1:solid10, component1:solid10_2

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid10_2"

'@ boolean add shapes: component1:solid10, component1:solid10_4_1

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Solid.Add "component1:solid10", "component1:solid10_4_1"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1222"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "759"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "49"
    .SetOrientation "Smart Mode"
    .SetDistance "0.329656"
    .SetViewVector "-0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "17054"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "13255"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "50"
    .SetOrientation "Smart Mode"
    .SetDistance "0.295478"
    .SetViewVector "-0.003491", "0.003480", "-0.999988"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "21102"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "21101"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "51"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.351425"
    .SetViewVector "-0.003491", "0.003480", "-0.999988"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "21101"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "24920"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "52"
    .SetOrientation "Smart Mode"
    .SetDistance "-1.460858"
    .SetViewVector "-0.003491", "-0.000011", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3350"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5263"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "53"
    .SetOrientation "Smart Mode"
    .SetDistance "0.276709"
    .SetViewVector "-0.003491", "-0.000011", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "29216"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "29373"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "54"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.920208"
    .SetViewVector "-0.003491", "-0.000011", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5456"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5451"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "55"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.295241"
    .SetViewVector "-0.003491", "-0.000010", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5354"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5358"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "56"
    .SetOrientation "Smart Mode"
    .SetDistance "0.186573"
    .SetViewVector "-0.003491", "-0.000015", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "28856"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "28861"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "57"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.276962"
    .SetViewVector "-0.003491", "-0.000015", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick edge

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEdgeFromId "component1:solid10", "39272", "28857"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "58"
    .SetOrientation "Smart Mode"
    .SetDistance "0.138999"
    .SetViewVector "-0.003491", "-0.000009", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "33317"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "33322"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "59"
    .SetOrientation "Smart Mode"
    .SetDistance "0.132991"
    .SetViewVector "-0.003491", "-0.000009", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5298"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5302"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "60"
    .SetOrientation "Smart Mode"
    .SetDistance "0.306908"
    .SetViewVector "-0.003491", "-0.000011", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "37274"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "37279"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "61"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.094005"
    .SetViewVector "-0.003491", "-0.000011", "-0.999994"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1222"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "759"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "62"
    .SetOrientation "Smart Mode"
    .SetDistance "0.284674"
    .SetViewVector "-0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "17054"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "13255"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "63"
    .SetOrientation "Smart Mode"
    .SetDistance "0.202908"
    .SetViewVector "-0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "21101"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "24920"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "64"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.190546"
    .SetViewVector "0.000000", "-0.000009", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5354"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5358"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "65"
    .SetOrientation "Smart Mode"
    .SetDistance "0.197045"
    .SetViewVector "0.000000", "-0.000009", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "28861"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "28856"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "66"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.225015"
    .SetViewVector "0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "33317"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "33322"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "67"
    .SetOrientation "Smart Mode"
    .SetDistance "0.162132"
    .SetViewVector "0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5298"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5302"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "68"
    .SetOrientation "Smart Mode"
    .SetDistance "0.364355"
    .SetViewVector "0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "37274"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "37279"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "69"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.151548"
    .SetViewVector "0.000000", "-0.000011", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "611"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "148"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "70"
    .SetOrientation "Smart Mode"
    .SetDistance "0.593409"
    .SetViewVector "-0.000000", "-0.000015", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "1329"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "3242"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "71"
    .SetOrientation "Smart Mode"
    .SetDistance "0.570916"
    .SetViewVector "0.000000", "-0.000026", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5456"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "5451"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "72"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.341777"
    .SetViewVector "0.000000", "-0.000026", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "9191"

'@ pick end point

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
Pick.PickEndpointFromId "component1:solid10", "9188"

'@ define distance dimension

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
With Dimension
    .Reset
    .CreationType "picks"
    .SetType "Distance"
    .SetID "73"
    .SetOrientation "Smart Mode"
    .SetDistance "-0.325697"
    .SetViewVector "0.000000", "-0.000026", "-1.000000"
    .SetConnectedElement1 "component1:solid10"
    .SetConnectedElement2 "component1:solid10"
    .Create
End With

Pick.ClearAllPicks

'@ change solver type

'[VERSION]2021.1|30.0.1|20201110[/VERSION]
ChangeSolverType "HF Frequency Domain"

