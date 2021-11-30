﻿within AixLib.ThermalZones.ReducedOrder.ThermalZone;
model ThermalZone_withPools
  "Thermal zone containing moisture balance and swimming pools"
   extends
    AixLib.ThermalZones.ReducedOrder.ThermalZone.BaseClasses.PartialThermalZone_withPools;

  replaceable model corG = SolarGain.CorrectionGDoublePane
    constrainedby
    AixLib.ThermalZones.ReducedOrder.SolarGain.BaseClasses.PartialCorrectionG
    "Model for correction of solar transmission"
    annotation(choicesAllMatching=true);
  parameter Integer internalGainsMode = 1
     "decides which internal gains model for persons is used";
  parameter Boolean use_AirExchange = false
    "Consider infiltration and ventilation by setting true";

  // Heater/ cooler parameters
  parameter Boolean recOrSep=true "Use record or seperate parameters"
    annotation (Dialog(tab="IdealHeaterCooler", group="Modes"), choices(choice =  false
        "Seperate",choice = true "Record",radioButtons = true));
  parameter Boolean Heater_on=true "Activates the heater"
    annotation (Dialog(tab="IdealHeaterCooler", group="Heater", enable=not recOrSep));
  parameter Real h_heater=0 "Upper limit controller output of the heater"
    annotation (Dialog(tab="IdealHeaterCooler", group="Heater", enable=not recOrSep));
  parameter Real l_heater=0 "Lower limit controller output of the heater"
    annotation (Dialog(tab="IdealHeaterCooler", group="Heater", enable=not recOrSep));
  parameter Real KR_heater=1000 "Gain of the heating controller"
    annotation (Dialog(tab="IdealHeaterCooler", group="Heater", enable=not recOrSep));
  parameter Modelica.SIunits.Time TN_heater=1
    "Time constant of the heating controller"
    annotation (Dialog(tab="IdealHeaterCooler", group="Heater", enable=not recOrSep));
  parameter Boolean Cooler_on=true "Activates the cooler"
    annotation (Dialog(tab="IdealHeaterCooler", group="Cooler", enable=not recOrSep));
  parameter Real h_cooler=0 "Upper limit controller output of the cooler"
    annotation (Dialog(tab="IdealHeaterCooler", group="Cooler", enable=not recOrSep));
  parameter Real l_cooler=0 "Lower limit controller output of the cooler"
    annotation (Dialog(tab="IdealHeaterCooler", group="Cooler", enable=not recOrSep));
  parameter Real KR_cooler=1000 "Gain of the cooling controller"
    annotation (Dialog(tab="IdealHeaterCooler", group="Cooler", enable=not recOrSep));
  parameter Modelica.SIunits.Time TN_cooler=1
    "Time constant of the cooling controller"
    annotation (Dialog(tab="IdealHeaterCooler", group="Cooler", enable=not recOrSep));

  // CO2 parameters
  parameter Modelica.SIunits.MassFraction XCO2_amb=6.12157E-4
    "Massfraction of CO2 in atmosphere (equals 403ppm)"
    annotation (Dialog(tab="CO2", enable=use_C_flow));
  parameter Modelica.SIunits.Area areaBod=1.8
    "Body surface area source SIA 2024:2015"
    annotation (Dialog(tab="CO2", enable=use_C_flow));
  parameter Modelica.SIunits.DensityOfHeatFlowRate metOnePerSit=58
    "Metabolic rate of a relaxed seated person  [1 Met = 58 W/m^2]"
    annotation (Dialog(tab="CO2", enable=use_C_flow));

  AixLib.BoundaryConditions.InternalGains.Humans.HumanSensibleHeatTemperatureDependent humanSenHeaDependent(
    final ratioConvectiveHeat=zoneParam.ratioConvectiveHeatPeople,
    final roomArea=zoneParam.AZone,
    final specificPersons=zoneParam.specificPeople,
    final activityDegree=zoneParam.activityDegree,
    final specificHeatPerPerson=zoneParam.fixedHeatFlowRatePersons) if ATot > 0 and internalGainsMode == 1 annotation (Placement(transformation(extent={{56,-34},
            {76,-14}})));

  AixLib.BoundaryConditions.InternalGains.Humans.HumanSensibleHeatTemperatureIndependent humanSenHeaIndependent(
    final ratioConvectiveHeat=zoneParam.ratioConvectiveHeatPeople,
    final roomArea=zoneParam.AZone,
    final specificPersons=zoneParam.specificPeople,
    final specificHeatPerPerson=zoneParam.fixedHeatFlowRatePersons) if ATot > 0 and internalGainsMode == 2 annotation (Placement(transformation(extent={{56,-34},
            {76,-14}})));

  AixLib.BoundaryConditions.InternalGains.Humans.HumanTotalHeatTemperatureDependent humanTotHeaDependent(
    final ratioConvectiveHeat=zoneParam.ratioConvectiveHeatPeople,
    final roomArea=zoneParam.AZone,
    final specificPersons=zoneParam.specificPeople,
    final activityDegree=zoneParam.activityDegree,
    final specificHeatPerPerson=zoneParam.fixedHeatFlowRatePersons) if ATot > 0 and internalGainsMode == 3 annotation (Placement(transformation(extent={{56,-34},
            {76,-14}})));

  replaceable AixLib.BoundaryConditions.InternalGains.Machines.MachinesAreaSpecific machinesSenHea(
    final ratioConv=zoneParam.ratioConvectiveHeatMachines,
    final intGainsMachinesRoomAreaSpecific=zoneParam.internalGainsMachinesSpecific,
    final roomArea=zoneParam.AZone) if ATot > 0 "Internal gains from machines" annotation (Placement(transformation(extent={{56,-56},
            {76,-37}})));
  replaceable AixLib.BoundaryConditions.InternalGains.Lights.LightsAreaSpecific lights(
    final ratioConv=zoneParam.ratioConvectiveHeatLighting,
    final lightingPowerRoomAreaSpecific=zoneParam.lightingPowerSpecific,
    final roomArea=zoneParam.AZone) if ATot > 0 "Internal gains from light" annotation (Placement(transformation(extent={{56,-78},
            {76,-59}})));

  corG corGMod(
    final n=zoneParam.nOrientations,
    final UWin=zoneParam.UWin) if
    sum(zoneParam.ATransparent) > 0 "Correction factor for solar transmission"
    annotation (Placement(transformation(extent={{-16,43},{-4,55}})));
  EquivalentAirTemperature.VDI6007WithWindow eqAirTempWall(
    withLongwave=true,
    final n=zoneParam.nOrientations,
    final wfWall=zoneParam.wfWall,
    final wfWin=zoneParam.wfWin,
    final wfGro=zoneParam.wfGro,
    final hConWallOut=zoneParam.hConWallOut,
    final hRad=zoneParam.hRadWall,
    final hConWinOut=zoneParam.hConWinOut,
    final aExt=zoneParam.aExt,
    final TGro=zoneParam.TSoil) if (sum(zoneParam.AExt) + sum(zoneParam.AWin)) > 0
    "Computes equivalent air temperature"
    annotation (Placement(transformation(extent={{-38,10},{-26,22}})));

  EquivalentAirTemperature.VDI6007 eqAirTempRoof(
    final wfGro=0,
    final n=zoneParam.nOrientationsRoof,
    final aExt=zoneParam.aRoof,
    final wfWall=zoneParam.wfRoof,
    final hConWallOut=zoneParam.hConRoofOut,
    final hRad=zoneParam.hRadRoof,
    final wfWin=fill(0, zoneParam.nOrientationsRoof),
    final TGro=273.15) if zoneParam.ARoof > 0
    "Computes equivalent air temperature for roof"
    annotation (Placement(transformation(extent={{-40,66},{-28,78}})));
  Modelica.Blocks.Sources.Constant constSunblindRoof[zoneParam.nOrientationsRoof](
     each k=0)
     "Sets sunblind signal to zero (open)"
     annotation (Placement(
        transformation(
        extent={{3,-3},{-3,3}},
        rotation=90,
        origin={-36,95})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilWall[zoneParam.nOrientations](
    each final outSkyCon=true,
    each final outGroCon=true,
    each final lat=zoneParam.lat,
    final azi=zoneParam.aziExtWalls,
    final til=zoneParam.tiltExtWalls)
    "Calculates diffuse solar radiation on titled surface for both directions"
    annotation (Placement(transformation(extent={{-84,10},{-68,26}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTilWall[zoneParam.nOrientations](
    each final lat=zoneParam.lat,
    final azi=zoneParam.aziExtWalls,
    final til=zoneParam.tiltExtWalls)
    "Calculates direct solar radiation on titled surface for both directions"
    annotation (Placement(transformation(extent={{-84,31},{-68,48}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTilRoof[zoneParam.nOrientationsRoof](
    each final lat=zoneParam.lat,
    final azi=zoneParam.aziRoof,
    final til=zoneParam.tiltRoof)
    "Calculates direct solar radiation on titled surface for roof"
    annotation (Placement(transformation(extent={{-84,82},{-68,98}})));

  Utilities.Sources.HeaterCooler.HeaterCoolerPI heaterCooler(
    each h_heater=h_heater,
    each l_heater=l_heater,
    each KR_heater=KR_heater,
    each TN_heater=TN_heater,
    each h_cooler=h_cooler,
    each l_cooler=l_cooler,
    each KR_cooler=KR_cooler,
    each TN_cooler=TN_cooler,
    final zoneParam=zoneParam,
    each recOrSep=recOrSep,
    each Heater_on=Heater_on,
    each Cooler_on=Cooler_on,
    each staOrDyn=not zoneParam.withIdealThresholds) if (ATot > 0 or zoneParam.VAir
     > 0) and (recOrSep and (zoneParam.HeaterOn or zoneParam.CoolerOn)) or (
    not recOrSep and (Heater_on or Cooler_on))
                                      "Heater Cooler with PI control"
    annotation (Placement(transformation(extent={{62,26},{84,46}})));
  Utilities.Sources.HeaterCooler.HeaterCoolerController heaterCoolerController(zoneParam=
       zoneParam) if zoneParam.withIdealThresholds
    annotation (Placement(transformation(extent={{-9,-8},{9,8}},
        rotation=0,
        origin={69,18})));
  Modelica.Blocks.Interfaces.RealInput TSetCool(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) if ((recOrSep and zoneParam.CoolerOn) or (not recOrSep and Cooler_on))
           "Set point for cooler" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-108,8}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-96,40})));
  Modelica.Blocks.Interfaces.RealInput TSetHeat(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) if ((recOrSep and zoneParam.HeaterOn) or (not recOrSep and Heater_on))
           "Set point for heater" annotation (Placement(transformation(
        extent={{20,20},{-20,-20}},
        rotation=180,
        origin={-108,-16}),iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-96,12})));
  Modelica.Blocks.Interfaces.RealOutput PHeater(final quantity="HeatFlowRate",
      final unit="W") if (ATot > 0 or zoneParam.VAir > 0) and ((recOrSep and
    zoneParam.HeaterOn) or (not recOrSep and Heater_on))
    "Power for heating" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput PCooler(final quantity="HeatFlowRate",
      final unit="W") if (ATot > 0 or zoneParam.VAir > 0) and ((recOrSep and
    zoneParam.CoolerOn) or (not recOrSep and Cooler_on))
    "Power for cooling" annotation (Placement(transformation(extent={{100,-30},
            {120,-10}}), iconTransformation(extent={{100,-50},{120,-30}})));
  SolarGain.SimpleExternalShading simpleExternalShading(
    final nOrientations=zoneParam.nOrientations,
    final maxIrrs=zoneParam.maxIrr,
    final gValues=zoneParam.shadingFactor) if
    sum(zoneParam.ATransparent) > 0
    annotation (Placement(transformation(extent={{4,44},{10,50}})));


  // Air Exchange
  Controls.VentilationController.VentilationController ventCont(
    final useConstantOutput=zoneParam.useConstantACHrate,
    final baseACH=zoneParam.baseACH,
    final maxUserACH=zoneParam.maxUserACH,
    final maxOverheatingACH=zoneParam.maxOverheatingACH,
    final maxSummerACH=zoneParam.maxSummerACH,
    final winterReduction=zoneParam.winterReduction,
    final Tmean_start=zoneParam.T_start) if
       (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Calculates natural venitlation and infiltration"
    annotation (Placement(transformation(extent={{-68,-34},{-48,-14}})));
  Utilities.Psychrometrics.MixedTemperature mixedTemp if
       (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Mixes temperature of infiltration flow and mechanical ventilation flow"
    annotation (Placement(transformation(extent={{-66,-14},{-46,4}})));
  HighOrder.Components.DryAir.VarAirExchange airExc(final V=zoneParam.VAir) if
       (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange and not use_moisture_balance
    "Heat flow due to ventilation"
    annotation (Placement(transformation(extent={{-22,-12},{-6,4}})));

  Modelica.Blocks.Interfaces.RealInput ventTemp(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) if (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Ventilation and infiltration temperature"
    annotation (Placement(
        transformation(extent={{-128,-60},{-88,-20}}), iconTransformation(
          extent={{-106,-26},{-86,-6}})));
  Modelica.Blocks.Interfaces.RealInput ventRate(final quantity="VolumeFlowRate",
      final unit="1/h") if (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Ventilation and infiltration rate"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-108,-64}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,-42})));

  // Moisture
  Modelica.Blocks.Math.MultiSum SumQLat1_flow(nu=2) if (ATot > 0 or
    zoneParam.VAir > 0) and use_moisture_balance and not use_AirExchange
    annotation (Placement(transformation(extent={{-40,-68},{-28,-56}})));
  Modelica.Blocks.Math.MultiSum SumQLat2_flow(nu=3) if (ATot > 0 or
    zoneParam.VAir > 0) and use_moisture_balance and use_AirExchange
    annotation (Placement(transformation(extent={{-40,-68},{-28,-56}})));
  Modelica.Blocks.Sources.Constant noMoisturePerson(k=0) if
       internalGainsMode <> 3 and use_moisture_balance
    annotation (Placement(transformation(extent={{-54,-58},{-48,-52}})));
  Modelica.Blocks.Interfaces.RealOutput X_w if
       (ATot > 0 or zoneParam.VAir > 0) and use_moisture_balance
    "Humidity output" annotation (Placement(transformation(extent={{102,-96},{122,
            -76}}), iconTransformation(extent={{102,-96},{122,-76}})));
  Modelica.Blocks.Interfaces.RealInput ventHum(
    final quantity="MassFraction",
    final unit="kg/kg",
    min=0) if (ATot > 0 or zoneParam.VAir > 0) and use_moisture_balance and use_AirExchange
    "Ventilation and infiltration humidity" annotation (Placement(
        transformation(extent={{-128,-108},{-88,-68}}), iconTransformation(
          extent={{-106,-82},{-84,-60}})));
  HighOrder.Components.MoistAir.VarMoistAirExchange airExcMoi(final V=zoneParam.VAir) if
    (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange and use_moisture_balance
    "Heat flow due to ventilation"
    annotation (Placement(transformation(extent={{-22,-12},{-6,4}})));

  BoundaryConditions.InternalGains.Moisture.MoistureGains moistureGains(final
      roomArea=zoneParam.AZone, final specificMoistureProduction=zoneParam.internalGainsMoistureNoPeople) if ATot
     > 0 and use_moisture_balance
    "Internal moisture gains by plants, etc."
    annotation (Dialog(enable=use_moisture_balance, tab="Moisture"),
      Placement(transformation(extent={{-70,-66},{-62,-58}})));


  // CO2
  BoundaryConditions.InternalGains.CO2.CO2Balance cO2Balance(
    areaZon=zoneParam.AZone,
    actDeg=zoneParam.activityDegree,
    VZon=zoneParam.VAir,
    spePeo=zoneParam.specificPeople,
    final XCO2_amb=XCO2_amb,
    final areaBod=areaBod,
    final metOnePerSit=metOnePerSit) if (ATot > 0 or zoneParam.VAir > 0) and
    use_C_flow
    annotation (Placement(transformation(extent={{20,-74},{34,-60}})));
  Modelica.Blocks.Interfaces.RealOutput CO2Con if (ATot > 0 or zoneParam.VAir
     > 0) and use_C_flow "CO2 concentration in the thermal zone in ppm"
    annotation (Placement(transformation(extent={{102,-112},{122,-92}}),
        iconTransformation(extent={{102,-112},{122,-92}})));

  Modelica.Blocks.Sources.RealExpression XCO2(y=ROM.volMoiAir.C[1]) if (ATot >
    0 or zoneParam.VAir > 0) and use_C_flow
    "Mass fraction of co2 in ROM in kg_CO2/ kg_TotalAir"
    annotation (Placement(transformation(extent={{-8,-74},{10,-60}})));

  // protected: ThermalZone
protected
    Modelica.Blocks.Sources.Constant hConRoof(final k=(zoneParam.hConRoofOut + zoneParam.hRadRoof)*zoneParam.ARoof)
    "Outdoor coefficient of heat transfer for roof" annotation (Placement(transformation(extent={{-14,68},
            {-6,76}})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConRoof if
    zoneParam.ARoof > 0
    "Outdoor convective heat transfer of roof"
    annotation (Placement(transformation(extent={{5,5},{-5,-5}},rotation=0,
    origin={5,83})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemRoof if
    zoneParam.ARoof > 0
    "Prescribed temperature for roof outdoor surface temperature"
    annotation (Placement(transformation(extent={{-4.5,-4},{4.5,4}},
                                                                rotation=0,
    origin={-9.5,84})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemFloor if
    zoneParam.AFloor > 0
    "Prescribed temperature for floor plate outdoor surface temperature"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
    rotation=90,origin={48,36})));
  Modelica.Blocks.Sources.Constant TSoil(final k=zoneParam.TSoil) if zoneParam.AFloor
     > 0 or zoneParam.use_swimmingPools
    "Outdoor surface temperature for floor plate"
    annotation (Placement(transformation(extent={{4,-4},{-4,4}},
    rotation=180,origin={39,22})));
  Modelica.Blocks.Sources.Constant hConWall(final k=(zoneParam.hConWallOut + zoneParam.hRadWall)*sum(zoneParam.AExt))
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(transformation(extent={{4,-4},{
            -4,4}},                                                                                               rotation=180,
        origin={-2,16})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWall if
    sum(zoneParam.AExt) > 0
    "Outdoor convective heat transfer of walls"
    annotation (Placement(transformation(extent={{26,24},{16,14}})));
  Modelica.Blocks.Sources.Constant hConWin(final k=(zoneParam.hConWinOut + zoneParam.hRadWall)*sum(zoneParam.AWin))
    "Outdoor coefficient of heat transfer for windows" annotation (Placement(transformation(extent={{4,-4},{-4,4}}, rotation=90,
        origin={22,48})));
  Modelica.Thermal.HeatTransfer.Components.Convection theConWin if
    sum(zoneParam.AWin) > 0
    "Outdoor convective heat transfer of windows"
    annotation (Placement(transformation(extent={{26,30},{16,40}})));
  Modelica.Blocks.Math.Add solRadRoof[zoneParam.nOrientationsRoof]
    "Sums up solar radiation of both directions"
    annotation (Placement(transformation(extent={{-58,82},{-48,92}})));
  Modelica.Blocks.Math.Add solRadWall[zoneParam.nOrientations]
    "Sums up solar radiation of both directions"
    annotation (Placement(transformation(extent={{-54,22},{-44,32}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemWall if
    sum(zoneParam.AExt) > 0
    "Prescribed temperature for exterior walls outdoor surface temperature"
    annotation (Placement(transformation(extent={{-18,16},{-10,24}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemWin if
    sum(zoneParam.AWin) > 0
    "Prescribed temperature for windows outdoor surface temperature"
    annotation (Placement(transformation(extent={{4,31},{12,38}})));

  // protected: AirExchange
  Modelica.Blocks.Math.Add addInfVen if
       (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Combines infiltration and ventilation"
    annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-34,-28})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemVen if
       (ATot > 0 or zoneParam.VAir > 0) and use_AirExchange
    "Prescribed temperature for ventilation"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={-34,-4})));

  // protected: MoistAir
  Modelica.Blocks.Sources.RealExpression humVolAirROM(y=ROM.volMoiAir.X_w) if
       (ATot > 0 or zoneParam.VAir > 0) and use_moisture_balance
    annotation (Placement(transformation(extent={{-70,-58},{-60,-42}})));

public
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilRoof[zoneParam.nOrientationsRoof](
    each final outSkyCon=false,
    each final outGroCon=false,
    each final lat=zoneParam.lat,
    final azi=zoneParam.aziRoof,
    final til=zoneParam.tiltRoof)
    "Calculates diffuse solar radiation on titled surface for roof"
    annotation (Placement(transformation(extent={{-84,61},{-68,77}})));

// ***************************************
 // CHANGES FOR SWIMMING POOL:
 //***************************************

  replaceable package MediumWater = AixLib.Media.Water  "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = AixLib.Media.Water "Water")),
        Dialog(tab="Moisture", group="Swimming Pools"));

  final parameter Boolean use_swimmingPools=zoneParam.use_swimmingPools "Are swimming pools in this zone?" annotation (Dialog(tab="Moisture", group="Swimming Pools"));

  final parameter Integer numPools=zoneParam.numPools
   "Number of Swimming Pools" annotation (Dialog(tab="Moisture", group="Swimming Pools", enable = use_swimmingPools));

  final parameter AixLib.DataBase.Pools.IndoorSwimmingPoolBaseRecord poolParam[numPools]= zoneParam.poolParam
    "Setup for Swimming Pools" annotation (choicesAllMatching=false,Dialog(tab="Moisture", group="Swimming Pools", enable = use_swimmingPools));

  parameter Boolean use_idealHeaterPool = true "Has to be constitent with pool record" annotation(Dialog(tab="Moisture", group="Swimming Pools"));


  AixLib.Fluid.Pools.IndoorSwimmingPool indoorSwimmingPool[numPools](
      poolParam=poolParam, redeclare package WaterMedium = MediumWater) if
                               use_swimmingPools and  ATot > 0
    annotation (Placement(transformation(extent={{-68,-86},{-52,-72}})));

  Modelica.Blocks.Interfaces.RealOutput PPool(
      final quantity="Power", final unit="W") if
         use_swimmingPools and  ATot > 0 "Power for Pumps"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput QHeatPools(
      final quantity="HeatFlowRate",
      final unit="W") if
         use_swimmingPools and  ATot > 0 and use_idealHeaterPool
    "Heat demands of all pools in zone to heat pool water" annotation (
      Placement(transformation(extent={{100,-62},{120,-42}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Math.MultiSum sumPoolPPump(nu=numPools) if use_swimmingPools and ATot > 0
    "Sum up electriical energy consumption of the circulation pump of all swimming pools"
    annotation (Placement(transformation(extent={{-38,-86},{-28,-76}})));
  Modelica.Blocks.Math.MultiSum sumPoolQHeat(nu=numPools) if use_swimmingPools and ATot > 0
    "Sum up heat demands of all swimming pools"
    annotation (Placement(transformation(extent={{-38,-86},{-28,-76}})));
  Modelica.Blocks.Math.MultiSum sumPoolFreshWater(nu=numPools) if
    use_swimmingPools and ATot > 0 "Sum up fresh water demands of all swimming pools"
    annotation (Placement(transformation(extent={{-38,-86},{-28,-76}})));

  Modelica.Blocks.Interfaces.RealInput openingHours if use_swimmingPools and
    ATot > 0
         "Input profiles for opening hours" annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={50,-100}),iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={52,-84})));



  Modelica.Blocks.Interfaces.RealOutput PoolFreshWater if use_swimmingPools
     and ATot > 0
    annotation (Placement(transformation(extent={{100,-76},{120,-56}})));
  Modelica.Fluid.Interfaces.FluidPort_b fromPool[numPools](redeclare final
      package Medium = MediumWater) if  use_swimmingPools and ATot > 0 and
    use_idealHeaterPool == false  "Outlet of heat exchanger for pool heating"
                                                      annotation (Placement(transformation(
          extent={{-60,-112},{-40,-92}}), iconTransformation(extent={{90,24},{110,
            44}})));
  Modelica.Fluid.Interfaces.FluidPort_a toPool[numPools](redeclare final
      package Medium = MediumWater) if
                                     use_swimmingPools and ATot > 0 and
    use_idealHeaterPool == false "Inlet for heat exchanger for pool heating"
                                                     annotation (Placement(transformation(
          extent={{-84,-112},{-64,-92}}), iconTransformation(extent={{90,-12},{110,
            8}})));
equation
    if use_swimmingPools and (ATot > 0) then
      for i in 1:numPools loop
      connect(humVolAirROM.y, indoorSwimmingPool[i].X_w) annotation (Line(points={{-59.5,
              -50},{-56,-50},{-56,-64},{-54,-64},{-54,-72},{-54.8,-72},{-54.8,-71.51}},
                                                        color={0,0,127}));
      connect(TSoil.y, indoorSwimmingPool[i].TSoil) annotation (Line(points={{43.4,22},
              {44,22},{44,-74.31},{-51.76,-74.31}}, color={0,0,127}));
      connect(ROM.intGainsConv,indoorSwimmingPool[i].convPoolSurface)  annotation (Line(points={{86,78},
              {10,78},{10,-71.72},{-61.12,-71.72}},                                                                                    color={
              191,0,0}));
      connect(indoorSwimmingPool[i].radPoolSurface, ROM.intGainsRad)   annotation (Line(points={{-65.44,-71.72},{-65.44,-70},{-72,-70},{-72,6},
              {86,6},{86,82}},
            color={95,95,95}));
      connect(indoorSwimmingPool[i].TAir, TAir) annotation (Line(points={{-57.68,
              -71.51},{-16,-71.51},{-16,-62},{-4,-62},{-4,-6},{94,-6},{94,80},{110,
              80}},                        color={0,0,127}));
      connect(indoorSwimmingPool[i].PPool,sumPoolPPump. u[i]) annotation (Line(points={{-51.2,
              -82.64},{-38,-82.64},{-38,-81}},                 color={0,0,127}));
      connect(indoorSwimmingPool[i].MFlowFreshWater,sumPoolFreshWater. u[i]) annotation (Line(points={{-51.2,
              -85.02},{-38,-85.02},{-38,-81}},
            color={0,0,127}));
      connect(indoorSwimmingPool[i].openingHours, openingHours) annotation (
          Line(points={{-68.08,-73.19},{-78,-73.19},{-78,-88},{48,-88},{48,-100},
              {50,-100}},color={0,0,127}));
      connect(indoorSwimmingPool[i].T_Pool, ROM.T[i+1]) annotation (Line(points={{-51.2,
              -72.56},{-51.2,-68},{-14,-68},{-14,-42},{30,-42},{30,64},{37.2,64},
              {37.2,64.4}},             color={0,0,
          127}));
      connect(indoorSwimmingPool[i].QEvap, ROM.QLat_flow[i + 1]) annotation (
          Line(points={{-51.2,-78.16},{-51.2,-70},{-22,-70},{-22,-62},{-4,-62},{
              -4,-6},{32,-6},{32,59.6},{37,59.6}},
            color={0,0,127}));
      connect(ROM.TAir, indoorSwimmingPool[i].TAir) annotation (Line(points={{87,90},
          {98,90},{98,-2},{36,-2},{36,-38},{-57.68,-38},{-57.68,-71.51}}, color=
         {0,0,127}));
      connect(indoorSwimmingPool[i].persons, intGains[1]) annotation (Line(points={{-68.08,
              -75.85},{-74,-75.85},{-74,-88},{80,-88},{80,-113.333}},
                                                              color={0,0,127}));
      if use_idealHeaterPool then
              connect(indoorSwimmingPool[i].QPool,sumPoolQHeat. u[i]) annotation (Line(points={{-51.2,
              -80.26},{-52,-80.26},{-52,-81},{-38,-81}},color={0,0,127}));
      else
          connect(fromPool[i], indoorSwimmingPool[i].fromPool);
          connect(toPool[i], indoorSwimmingPool[i].toPool);
      end if;
    end for;
    connect(sumPoolPPump.y, PPool) annotation (Line(points={{-27.15,-81},{35.425,
            -81},{35.425,-40},{110,-40}},        color={0,0,127}));
    connect(sumPoolQHeat.y, QHeatPools) annotation (Line(points={{-27.15,-81},{94,
            -81},{94,-54},{100,-54},{100,-52},{110,-52}},
                                         color={0,0,127}));
    connect(sumPoolFreshWater.y, PoolFreshWater) annotation (Line(points={{-27.15,
            -81},{98,-81},{98,-66},{110,-66}},
                                             color={0,0,127}));end if;



  connect(intGains[2], machinesSenHea.uRel) annotation (Line(points={{80,-100},{
          80,-94},{78,-94},{78,-88},{48,-88},{48,-46.5},{56,-46.5}}, color={0,0,
          127}));
  connect(intGains[3], lights.uRel) annotation (Line(points={{80,-86.6667},{80,
          -86},{50,-86},{50,-68.5},{56,-68.5}},
                                           color={0,0,127}));
  connect(lights.convHeat, ROM.intGainsConv) annotation (Line(points={{75,-62.8},
          {80,-62.8},{80,-64},{88,-64},{88,78},{86,78}},
                                       color={191,0,0}));
  connect(machinesSenHea.convHeat, ROM.intGainsConv) annotation (Line(points={{75,
          -40.8},{82,-40.8},{82,-40},{88,-40},{88,78},{86,78}},
                                              color={191,0,0}));
  connect(intGains[1], humanSenHeaDependent.uRel) annotation (Line(points={{80,
          -113.333},{80,-92},{46,-92},{46,-24},{56,-24}},
                                                color={0,0,127}));
  connect(humanSenHeaDependent.convHeat, ROM.intGainsConv) annotation (Line(
        points={{75,-18},{88,-18},{88,78},{86,78}}, color={191,0,0}));
  connect(ROM.intGainsConv, humanSenHeaDependent.TRoom) annotation (Line(points={{86,78},
          {88,78},{88,-8},{57,-8},{57,-15}},           color={191,0,0}));
  connect(humanSenHeaDependent.radHeat, ROM.intGainsRad) annotation (Line(
        points={{75,-30},{94,-30},{94,82},{86,82}}, color={95,95,95}));
  connect(intGains[1], humanSenHeaIndependent.uRel) annotation (Line(points={{80,
          -113.333},{80,-92},{46,-92},{46,-24},{56,-24}}, color={0,0,127}));
  connect(humanSenHeaIndependent.convHeat, ROM.intGainsConv) annotation (Line(
        points={{75,-18},{88,-18},{88,78},{86,78}}, color={191,0,0}));
  connect(ROM.intGainsConv, humanSenHeaIndependent.TRoom) annotation (Line(
        points={{86,78},{88,78},{88,-8},{57,-8},{57,-15}},   color={191,0,0}));
  connect(humanSenHeaIndependent.radHeat, ROM.intGainsRad) annotation (Line(
        points={{75,-30},{94,-30},{94,82},{86,82}}, color={95,95,95}));
  connect(intGains[1], humanTotHeaDependent.uRel) annotation (Line(points={{80,
          -113.333},{80,-92},{46,-92},{46,-24},{56,-24}},
                                                color={0,0,127}));
  connect(humanTotHeaDependent.convHeat, ROM.intGainsConv) annotation (Line(
        points={{75,-18},{88,-18},{88,78},{86,78}}, color={191,0,0}));
  connect(ROM.intGainsConv, humanTotHeaDependent.TRoom) annotation (Line(points={{86,78},
          {88,78},{88,-8},{57,-8},{57,-15}},           color={191,0,0}));
  connect(humanTotHeaDependent.radHeat, ROM.intGainsRad) annotation (Line(
        points={{75,-30},{94,-30},{94,82},{86,82}}, color={95,95,95}));
  connect(machinesSenHea.radHeat, ROM.intGainsRad) annotation (Line(points={{75,
          -52.2},{94,-52.2},{94,82},{86,82}}, color={95,95,95}));
  connect(lights.radHeat, ROM.intGainsRad) annotation (Line(points={{75,-74.2},{
          94,-74.2},{94,82},{86,82}}, color={95,95,95}));
  connect(eqAirTempWall.TEqAirWin, preTemWin.T) annotation (Line(points={{-25.4,
          18.28},{-24,18.28},{-24,30},{2,30},{2,34.5},{3.2,34.5}}, color={0,0,127}));
  connect(eqAirTempWall.TEqAir, preTemWall.T) annotation (Line(points={{-25.4,16},
          {-20,16},{-20,20},{-18.8,20}}, color={0,0,127}));
  connect(HDirTilWall.H, corGMod.HDirTil) annotation (Line(points={{-67.2,39.5},
          {-58,39.5},{-58,52},{-38,52},{-38,52.6},{-17.2,52.6}}, color={0,0,127}));
  connect(HDirTilWall.H, solRadWall.u1) annotation (Line(points={{-67.2,39.5},{-58,
          39.5},{-58,30},{-55,30}}, color={0,0,127}));
  connect(HDirTilWall.inc, corGMod.inc) annotation (Line(points={{-67.2,36.1},{-64,
          36.1},{-64,36},{-60,36},{-60,45.4},{-17.2,45.4}}, color={0,0,127}));
  connect(HDifTilWall.H, solRadWall.u2) annotation (Line(points={{-67.2,18},{-60,
          18},{-60,24},{-55,24}}, color={0,0,127}));
  connect(HDifTilWall.HGroDifTil, corGMod.HGroDifTil) annotation (Line(points={{
          -67.2,13.2},{-62,13.2},{-62,48},{-40,48},{-40,47.8},{-17.2,47.8}},
        color={0,0,127}));
  connect(solRadWall.y, eqAirTempWall.HSol) annotation (Line(points={{-43.5,27},
          {-42,27},{-42,19.6},{-39.2,19.6}}, color={0,0,127}));
  connect(weaBus.TBlaSky, eqAirTempWall.TBlaSky) annotation (Line(
      points={{-100,34},{-86,34},{-86,10},{-60,10},{-60,16},{-39.2,16}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, eqAirTempWall.TDryBul) annotation (Line(
      points={{-100,34},{-86,34},{-86,10},{-60,10},{-60,12.4},{-39.2,12.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTilWall.HSkyDifTil, corGMod.HSkyDifTil) annotation (Line(points={{
          -67.2,22.8},{-64,22.8},{-64,50},{-40,50},{-40,50.2},{-17.2,50.2}},
        color={0,0,127}));
  connect(theConWin.solid, ROM.window) annotation (Line(points={{26,35},{28,35},
          {28,78},{38,78}}, color={191,0,0}));
  connect(theConWall.solid, ROM.extWall) annotation (Line(points={{26,19},{29,19},
          {29,70},{38,70}}, color={191,0,0}));
  connect(weaBus.TDryBul, eqAirTempRoof.TDryBul) annotation (Line(
      points={{-100,34},{-86,34},{-86,60},{-46,60},{-46,68.4},{-41.2,68.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TBlaSky, eqAirTempRoof.TBlaSky) annotation (Line(
      points={{-100,34},{-86,34},{-86,60},{-46,60},{-46,72},{-41.2,72}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTilRoof.H, solRadRoof.u1)
    annotation (Line(points={{-67.2,90},{-59,90}}, color={0,0,127}));
  connect(HDifTilRoof.H, solRadRoof.u2) annotation (Line(points={{-67.2,69},{-64,
          69},{-64,84},{-59,84}}, color={0,0,127}));
  connect(solRadRoof.y, eqAirTempRoof.HSol) annotation (Line(points={{-47.5,87},
          {-44,87},{-44,75.6},{-41.2,75.6}}, color={0,0,127}));
  connect(constSunblindRoof.y, eqAirTempRoof.sunblind) annotation (Line(points={
          {-36,91.7},{-36,79.2},{-34,79.2}}, color={0,0,127}));
  connect(TSoil.y, preTemFloor.T)
    annotation (Line(points={{43.4,22},{48,22},{48,28.8}}, color={0,0,127}));
  connect(preTemFloor.port, ROM.floor)
    annotation (Line(points={{48,42},{48,56},{62,56}}, color={191,0,0}));
  connect(preTemRoof.port, theConRoof.fluid)
    annotation (Line(points={{-5,84},{0,84},{0,83}}, color={191,0,0}));
  connect(theConRoof.Gc, hConRoof.y)
    annotation (Line(points={{5,78},{5,72},{-5.6,72}}, color={0,0,127}));
  connect(eqAirTempRoof.TEqAir, preTemRoof.T) annotation (Line(points={{-27.4,72},
          {-27.4,84},{-14.9,84}}, color={0,0,127}));
  connect(theConRoof.solid, ROM.roof) annotation (Line(points={{10,83},{14,83},{
          14,92},{60.9,92}}, color={191,0,0}));
  for i in 1:zoneParam.nOrientations loop
    connect(weaBus, HDifTilWall[i].weaBus) annotation (Line(
        points={{-100,34},{-100,34},{-86,34},{-86,18},{-84,18}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(HDirTilWall[i].weaBus, weaBus) annotation (Line(
        points={{-84,39.5},{-86,39.5},{-86,46},{-86,34},{-100,34}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
  end for;
  for i in 1:zoneParam.nOrientationsRoof loop
    connect(weaBus, HDifTilRoof[i].weaBus) annotation (Line(
        points={{-100,34},{-86,34},{-86,69},{-84,69}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(weaBus, HDirTilRoof[i].weaBus) annotation (Line(
        points={{-100,34},{-86,34},{-86,90},{-84,90}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
  end for;
  connect(preTemWall.port, theConWall.fluid) annotation (Line(points={{-10,20},{
          18,20},{18,19},{16,19}}, color={191,0,0}));
  connect(preTemWin.port, theConWin.fluid)
    annotation (Line(points={{12,34.5},{16,34.5},{16,35}}, color={191,0,0}));
  connect(hConWall.y, theConWall.Gc)
    annotation (Line(points={{2.4,16},{21,16},{21,14}}, color={0,0,127}));
  connect(hConWin.y, theConWin.Gc)
    annotation (Line(points={{22,43.6},{22,40},{21,40}}, color={0,0,127}));
  connect(heaterCoolerController.heaterActive, heaterCooler.heaterActive)
    annotation (Line(points={{76.38,19.6},{80,19.6},{80,28},{80.48,28},{80.48,28.8}},
        color={255,0,255}));
  connect(heaterCoolerController.coolerActive, heaterCooler.coolerActive)
    annotation (Line(points={{76.38,16.4},{76.38,16},{66,16},{66,26},{65.3,26},{
          65.3,28.8}}, color={255,0,255}));
  connect(TSetHeat, heaterCooler.setPointHeat) annotation (Line(points={{-108,-16},
          {-86,-16},{-86,6},{74,6},{74,18},{75.42,18},{75.42,28.8}}, color={0,0,
          127}));
  connect(TSetCool, heaterCooler.setPointCool) annotation (Line(points={{-108,8},
          {70,8},{70,16},{70.36,16},{70.36,28.8}}, color={0,0,127}));
  connect(heaterCooler.coolingPower, PCooler) annotation (Line(points={{84,35.4},
          {84,-2},{98,-2},{98,-20},{110,-20}}, color={0,0,127}));
  connect(heaterCooler.heatingPower, PHeater) annotation (Line(points={{84,40},{
          90,40},{90,0},{110,0}}, color={0,0,127}));
  connect(weaBus, heaterCoolerController.weaBus) annotation (Line(
      points={{-100,34},{-86,34},{-86,10},{58,10},{58,21.44},{62.07,21.44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(heaterCooler.heatCoolRoom, intGainsConv) annotation (Line(points={{82.9,
          32},{96,32},{96,20},{104,20}}, color={191,0,0}));
  connect(corGMod.solarRadWinTrans, simpleExternalShading.solRadWin)
    annotation (Line(points={{-3.4,49},{2.3,49},{2.3,48.92},{3.88,48.92}},
        color={0,0,127}));
  connect(solRadWall.y, simpleExternalShading.solRadTot) annotation (Line(
        points={{-43.5,27},{-38,27},{-38,42},{0,42},{0,48},{3.94,48},{3.94,47.06}},
        color={0,0,127}));
  connect(simpleExternalShading.shadingFactor, eqAirTempWall.sunblind)
    annotation (Line(points={{10.06,44.6},{10,44.6},{10,40},{-32,40},{-32,23.2}},
        color={0,0,127}));
  connect(simpleExternalShading.corrIrr, ROM.solRad) annotation (Line(points={{9.94,
          47.24},{9.94,52},{26,52},{26,89},{37,89}}, color={0,0,127}));

  connect(ventCont.y, addInfVen.u1) annotation (Line(
      points={{-49,-24},{-41.2,-24},{-41.2,-24.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(intGains[1], ventCont.relOccupation) annotation (Line(points={{80,
          -113.333},{80,-92},{46,-92},{46,-36},{-68,-36},{-68,-30}},     color=
          {0,0,127}));
  connect(ventRate, addInfVen.u2) annotation (Line(points={{-108,-64},{-74,-64},
          {-74,-34},{-42,-34},{-42,-31.6},{-41.2,-31.6}},
                                      color={0,0,127}));
  connect(ventCont.y, mixedTemp.flowRate_flow2) annotation (Line(points={{-49,-24},
          {-46,-24},{-46,-12},{-65.6,-12},{-65.6,-11.3}},       color={0,0,127}));
  connect(ventRate, mixedTemp.flowRate_flow1) annotation (Line(points={{-108,-64},
          {-74,-64},{-74,-2.3},{-65.6,-2.3}},color={0,0,127}));
  connect(ventTemp, mixedTemp.temperature_flow1) annotation (Line(points={{-108,
          -40},{-76,-40},{-76,2.02},{-65.6,2.02}},   color={0,0,127}));
  connect(ROM.TAir, ventCont.Tzone) annotation (Line(points={{87,90},{56,90},{56,
          0},{-2,0},{-2,-14},{-72,-14},{-72,-18},{-68,-18}},      color={0,0,
          127}));
  connect(preTemVen.port, airExc.port_a)
    annotation (Line(points={{-30,-4},{-22,-4}},             color={191,0,0}));
  connect(mixedTemp.mixedTemperatureOut, preTemVen.T)
    annotation (Line(points={{-46,-5},{-42,-5},{-42,-4},{-38.8,-4}},
                                                     color={0,0,127}));
  connect(addInfVen.y, airExc.ventRate) annotation (Line(points={{-27.4,-28},{
          -24,-28},{-24,-10},{-21.2,-10},{-21.2,-9.12}},           color={0,0,
          127}));
  connect(airExc.port_b, ROM.intGainsConv) annotation (Line(points={{-6,-4},{44,
          -4},{44,0},{74,0},{74,78},{86,78}},  color={191,0,0}));
  connect(weaBus.TDryBul, mixedTemp.temperature_flow2) annotation (Line(
      points={{-100,34},{-86,34},{-86,10},{-78,10},{-78,-6.8},{-65.6,-6.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, ventCont.Tambient) annotation (Line(
      points={{-100,34},{-86,34},{-86,10},{-78,10},{-78,-24},{-68,-24}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  if internalGainsMode == 3 then
    connect(humanTotHeaDependent.QLat_flow, SumQLat1_flow.u[1]) annotation (
        Line(points={{75.6,-16},{92,-16},{92,-4},{8,-4},{8,-56},{-40,-56},{-40,-59.9}},
                          color={0,0,127}));
    connect(humanTotHeaDependent.QLat_flow, SumQLat2_flow.u[1]) annotation (
        Line(points={{75.6,-16},{92,-16},{92,-4},{8,-4},{8,-56},{-40,-56},{-40,-59.2}},
                          color={0,0,127}));
  else
    connect(noMoisturePerson.y, SumQLat1_flow.u[1]) annotation (Line(points={{-47.7,
            -55},{-40,-55},{-40,-59.9}}, color={0,0,127}));
    connect(noMoisturePerson.y, SumQLat2_flow.u[1]) annotation (Line(points={{-47.7,
            -55},{-40,-55},{-40,-59.2}}, color={0,0,127}));
  end if;
  connect(moistureGains.QLat_flow, SumQLat1_flow.u[2]) annotation (Line(points={{-61.6,
          -62},{-40,-62},{-40,-64.1}},                                    color=
         {0,0,127}));
  connect(moistureGains.QLat_flow, SumQLat2_flow.u[2]) annotation (Line(points={{-61.6,
          -62},{-40,-62}},                                                color=
         {0,0,127}));

  if (ATot > 0 or zoneParam.VAir > 0) and use_moisture_balance and use_AirExchange then
    connect(SumQLat2_flow.y, ROM.QLat_flow[1]) annotation (Line(points={{-26.98,
            -62},{-4,-62},{-4,4},{32,4},{32,59.6},{37,59.6}},
                                                            color={0,0,127}));
  end if;
  if (ATot > 0 or zoneParam.VAir > 0) and use_moisture_balance and not use_AirExchange then
    connect(SumQLat1_flow.y, ROM.QLat_flow[1]) annotation (Line(points={{-26.98,
            -62},{-4,-62},{-4,4},{32,4},{32,59.6},{37,59.6}},
                                                            color={0,0,127}));
  end if;
  connect(humVolAirROM.y, X_w) annotation (Line(points={{-59.5,-50},{4,-50},{4,-6},
          {96,-6},{96,-86},{112,-86}}, color={0,0,127}));
  connect(addInfVen.y, cO2Balance.airExc) annotation (Line(points={{-27.4,-28},{
          -24,-28},{-24,-40},{12,-40},{12,-64.9},{20,-64.9}},
                                                            color={0,0,127}));
  connect(cO2Balance.uRel, intGains[1]) annotation (Line(points={{20,-61.4},{20,
          -50},{80,-50},{80,-113.333}},                          color={0,0,127}));
  connect(cO2Balance.TAir, TAir) annotation (Line(points={{27,-60},{26,-60},{26,
          0},{96,0},{96,80},{110,80}},
                         color={0,0,127}));
  connect(cO2Balance.CO2Con, CO2Con) annotation (Line(points={{34.7,-71.2},{40,-71.2},
          {40,-82},{94,-82},{94,-102},{112,-102}},
                               color={0,0,127}));
  connect(cO2Balance.XCO2, XCO2.y) annotation (Line(points={{20,-68.4},{20,-67},
          {10.9,-67}}, color={0,0,127}));
  connect(ROM.C_flow[1], cO2Balance.mCO2_flow) annotation (Line(points={{37,84},
          {32,84},{32,-6},{50,-6},{50,-62.8},{34.7,-62.8}}, color={0,0,127}));
  connect(airExcMoi.port_a, preTemVen.port) annotation (Line(points={{-22,-4},{-30,-4}}, color={191,0,0}));
  connect(airExcMoi.ventRate, addInfVen.y) annotation (Line(points={{-21.2,
          -9.12},{-24,-9.12},{-24,-28},{-27.4,-28}}, color={0,0,127}));
  connect(airExcMoi.HumIn, ventHum) annotation (Line(points={{-21.2,-8},{-22,-8},
          {-22,-90},{-82,-90},{-82,-88},{-108,-88}},
                                 color={0,0,127}));
  connect(airExcMoi.port_b, ROM.intGainsConv) annotation (Line(points={{-6,-4},
          {58,-4},{58,78},{86,78}}, color={191,0,0}));
  connect(airExcMoi.QLat_flow, SumQLat2_flow.u[3]) annotation (Line(points={{-5.68,
          -8.96},{-6,-8.96},{-6,-40},{-56,-40},{-56,-64.8},{-40,-64.8}},
        color={0,0,127}));
  connect(humVolAirROM.y, airExcMoi.HumOut) annotation (Line(points={{-59.5,-50},
          {-4,-50},{-4,0},{-6,0},{-6,0.16},{-6.8,0.16}}, color={0,0,127}));
  connect(ROM.intGainsConv, intGainsRad) annotation (Line(points={{86,78},{92,
          78},{92,40},{104,40}}, color={191,0,0}));
  connect(moistureGains.TMoistureSource, ROM.T[1]) annotation (Line(points={{-61.76,
          -60.24},{-61.76,-60},{-56,-60},{-56,-40},{10,-40},{10,64},{37.2,64},{37.2,
          64.4}},                                 color={0,0,127}));

   annotation (Documentation(revisions="<html><ul>
  <li>November 20, 2020, by Katharina Breuer:<br/>
    Combine thermal zone models
  </li>
  <li>August 27, 2020, by Katharina Breuer:<br/>
    Add co2 balance
  </li>
  <li>January 09, 2020, by David Jansen:<br/>
    Integration of ideal heater and cooler into the thermal zone.
  </li>
  <li>July 10, 2019, by David Jansen and Martin Kremer:<br/>
    Integration of changeable internal gain models for humans.
  </li>
  <li>April, 2019, by Martin Kremer:<br/>
    Add moisture balance
  </li>
  <li>March 01, 2019, by Niklas Huelsenbeck:<br/>
    Integration of new Internal Gains models,
    HumanSensibleHeatAreaSpecific and MachinesAreaSpecific
  </li>
  <li>September 27, 2016, by Moritz Lauster:<br/>
    Reimplementation based on Annex60 and MSL models.
  </li>
  <li>March, 2012, by Moritz Lauster:<br/>
    First implementation.
  </li>
</ul>
</html>", info="<html>
<p>
  <b><span style=\"color: #008000;\">Overview</span></b>
</p>
<p>
  Comprehensive ready-to-use model for thermal zones, combining
  caclulation core, handling of solar radiation and internal gains.
  Core model is a <a href=
  \"AixLib.ThermalZones.ReducedOrder.RC.FourElements\">AixLib.ThermalZones.ReducedOrder.RC.FourElements</a>
  model. Conditional removements of the core model are passed-through
  and related models on thermal zone level are as well conditional. All
  models for solar radiation are part of Annex60 library. Internal
  gains are part of AixLib.
</p>
<p>
  Models for infiltration and natural ventilation, moisture and CO2
  balance are conditional and can be activated by setting the
  parameters true. Moisture is considered in internal gains.
</p>
<h4>
  Typical use and important parameters
</h4>
<p>
  All parameters are collected in one <a href=
  \"AixLib.DataBase.ThermalZones.ZoneBaseRecord\">AixLib.DataBase.ThermalZones.ZoneBaseRecord</a>
  record. Further parameters for medium, initialization and dynamics
  originate from <a href=
  \"AixLib.Fluid.Interfaces.LumpedVolumeDeclarations\">AixLib.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
  A typical use case is a single thermal zone connected via heat ports
  and fluid ports to a heating system. The thermal zone model serves as
  boundary condition for the heating system and calculates the room's
  reaction to external and internal heat sources. The model is used as
  thermal zone core model in <a href=
  \"AixLib.ThermalZones.ReducedOrder.Multizone.BaseClasses.PartialMultizone\">
  AixLib.ThermalZones.ReducedOrder.Multizone.BaseClasses.PartialMultizone</a>
</p>
<p>
  Dependent on the paramter <span style=
  \"font-family: Courier New;\">internalGainsMode</span> different models
  for internal gains by humans will be used. For a correct moisture
  balance the paramter should be set to <span style=
  \"font-family: Courier New;\">3</span>. Otherwise no moisture gain from
  persons will be considered. Using CO2 balance trace substances in the
  media package must be activated. For example <span style=
  \"font-family: Courier New;\">AixLib.Media.Air(extraPropertiesNames={\"C_Flow\"})</span>
  can be used.
</p>
<p>
  <b><span style=\"color: #008000;\">Assumptions</span></b>
</p>
<p>
  There is no moisture exchange through the walls or windows. Only
  moisture exchange is realized by the internal gains, through the
  fluid ports and over the ventilation moisture. This leads to a steady
  increase of moisture in the room, when there is no ventilation.
</p>
<p>
  The moisture balance was formulated considering the latent heat with
  the aim, that the temperature is not influenced by the moisture.For
  this reason every humidity source is assumed to be in gaseous state.
</p>
<h4>
  Accuracy
</h4>
<p>
  Due to usage of constant heat capacaty for steam and constant heat of
  evaporation, the temperature is slightly influenced. Comparing the
  ThermalZone with dry air to the ThermalZone with moist air, the
  maximum difference between the simulated air temperature in the zone
  is 0.07 K for weather data from San Francisco and using the zoneParam
  for office buildings. See therefore: <a href=
  \"AixLib.ThermalZones.ReducedOrder.Examples.ComparisonThermalZoneMoistAndDryAir\">
  ExampleComparisonMoistAndDryAir</a>
</p>
<h4>
  References
</h4>
<p>
  For automatic generation of thermal zone and multizone models as well
  as for datasets, see <a href=
  \"https://github.com/RWTH-EBC/TEASER\">https://github.com/RWTH-EBC/TEASER</a>
</p>
<ul>
  <li>German Association of Engineers: Guideline VDI 6007-1, March
  2012: Calculation of transient thermal response of rooms and
  buildings - Modelling of rooms.
  </li>
  <li>Lauster, M.; Teichmann, J.; Fuchs, M.; Streblow, R.; Mueller, D.
  (2014): Low order thermal network models for dynamic simulations of
  buildings on city district scale. In: Building and Environment 73, p.
  223–231. DOI: <a href=
  \"http://dx.doi.org/10.1016/j.buildenv.2013.12.016\">10.1016/j.buildenv.2013.12.016</a>.
  </li>
</ul>
<h4>
  Examples
</h4>
<p>
  See <a href=
  \"AixLib.ThermalZones.ReducedOrder.Examples.ThermalZone\">AixLib.ThermalZones.ReducedOrder.Examples.ThermalZone</a>.
</p>
</html>"), Diagram(graphics={
        Polygon(
          points={{30,10},{-88,10},{-88,58},{-24,58},{-24,26},{30,26},{30,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,-10},{92,-10},{92,-86},{42,-86},{42,-86},{42,-82},{42,-10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{65,-7},{90,-18}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Internal Gains"),
        Polygon(
          points={{30,100},{-88,100},{-88,60},{30,60},{30,100},{30,100},{30,100}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,62},{-44,50}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Exterior Walls"),
        Text(
          extent={{-8,98},{8,92}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Roof"),
        Polygon(
          points={{32,50},{56,50},{56,10},{32,10},{32,28},{32,26},{32,50}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{33,49},{54,42}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Floor Plate"),
        Polygon(
          points={{-22,58},{30,58},{30,28},{-22,28},{-22,36},{-22,28},{-22,58}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{3,59},{20,52}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Windows"),
        Rectangle(
          extent={{60,50},{90,10}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{58,48},{82,40}},
          lineColor={0,0,255},
          fillColor={212,221,253},
          fillPattern=FillPattern.Solid,
          textString="Heating
Cooling"),
        Rectangle(
          extent={{-72,-42},{-22,-88}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-48,-42},{-30,-50}},
          lineColor={0,0,255},
          fillColor={212,221,253},
          fillPattern=FillPattern.Solid,
          textString="Moisture"),
        Rectangle(
          extent={{-72,6},{-2,-38}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-24,-25},{-1,-36}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Ventilation
Infiltration
"),     Rectangle(
          extent={{-12,-42},{38,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-10,-72},{8,-80}},
          lineColor={0,0,255},
          fillColor={212,221,253},
          fillPattern=FillPattern.Solid,
          textString="CO2")}));
end ThermalZone_withPools;
