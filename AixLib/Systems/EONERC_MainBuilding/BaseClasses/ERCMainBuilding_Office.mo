within AixLib.Systems.EONERC_MainBuilding.BaseClasses;
record ERCMainBuilding_Office "ERCMainBuilding_Office"
  extends AixLib.DataBase.ThermalZones.ZoneBaseRecord(
    T_start=293.15,
    withAirCap=true,
    VAir=11625.0,
    AZone=3750.0,
    hRad=5.0,
    lat=0.88645272708792,
    nOrientations=6,
    AWin={235.01452205080633,0.0,235.01452205080633,18.419688916677693,0.0,18.419688916677693},
    ATransparent={235.01452205080633,0.0,235.01452205080633,18.419688916677693,0.0,18.419688916677693},
    hConWin=2.7000000000000006,
    RWin=0.000706709946254729,
    gWin=0.67,
    UWin=1.8936557576825381,
    ratioWinConRad=0.030000000000000002,
    AExt={705.0435661524191,1078.125,705.0435661524191,55.25906675003308,1078.125,55.25906675003308},
    hConExt=2.1135613604230428,
    nExt=1,
    RExt={8.701475321978062e-06},
    RExtRem=0.0004784192933947339,
    CExt={1118774211.315879},
    AInt=11437.5,
    hConInt=2.208196721311476,
    nInt=1,
    RInt={4.757126165231165e-06},
    CInt={1647564125.2213645},
    AFloor=0.0,
    hConFloor=0.0,
    nFloor=1,
    RFloor={0.00001},
    RFloorRem=0.00001,
    CFloor={0.00001},
    ARoof=0.0,
    hConRoof=0.0,
    nRoof=1,
    RRoof={0.00001},
    RRoofRem=0.00001,
    CRoof={0.00001},
    nOrientationsRoof=1,
    tiltRoof={0.0},
    aziRoof={0.0},
    wfRoof={0.0},
    aRoof=0.0,
    aExt=0.5,
    TSoil=286.15,
    hConWallOut=20.0,
    hRadWall=4.999999999999999,
    hConWinOut=19.999999999999996,
    hConRoofOut=0.0,
    hRadRoof=0.0,
    tiltExtWalls={1.5707963267948966,0.0,1.5707963267948966,1.5707963267948966,0.0,1.5707963267948966},
    aziExtWalls={0.0,0.0,3.141592653589793,-1.5707963267948966,0.0,1.5707963267948966},
    wfWall={0.18754321375242472,0.26798923986945666,0.18754321375242472,0.014699039130045114,0.0,0.014699039130045114},
    wfWin={0.4636598215245673,0.0,0.4636598215245673,0.036340178475432756,0.0,0.036340178475432756},
    wfGro=0.3275262543656038,
    specificPeople=0.05,
    activityDegree=1.2,
    fixedHeatFlowRatePersons=70,
    ratioConvectiveHeatPeople=0.5,
    internalGainsMoistureNoPeople=0.5,
    internalGainsMachinesSpecific=7.0,
    ratioConvectiveHeatMachines=0.6,
    lightingPowerSpecific=12.5,
    ratioConvectiveHeatLighting=0.6,
    useConstantACHrate=false,
    baseACH=0.2,
    maxUserACH=1.0,
    maxOverheatingACH={3.0,2.0},
    maxSummerACH={1.0,283.15,290.15},
    winterReduction={0.2,273.15,283.15},
    withAHU=false,
    minAHU=0.0,
    maxAHU=2.6,
    maxIrr = {100,100,100,100,100,0},
    shadingFactor = {0.7,0.7,0.7,0.7, 0.7,0},
    hHeat=101286.83770252361,
    lHeat=0,
    KRHeat=10000,
    TNHeat=1,
    HeaterOn=false,
    hCool=0,
    lCool=-1,
    KRCool=1000,
    TNCool=1,
    CoolerOn=false,
    TThresholdHeater=273.15 + 15,
    TThresholdCooler=273.15 + 22,
    withIdealThresholds=false);

end ERCMainBuilding_Office;