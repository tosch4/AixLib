within AixLib.DataBase.ThermalZones;
record SwimmingHallMultiplePools
  extends SwimminghallBaseRecord(
    use_swimmingPools=true,
    numPools=5,
    poolParam={
    AixLib.DataBase.Pools.TypesOfIndoorSwimmingPools.SportPool(use_idealHeatExchanger=false),
    AixLib.DataBase.Pools.TypesOfIndoorSwimmingPools.SportPool(use_idealHeatExchanger=false),
    AixLib.DataBase.Pools.TypesOfIndoorSwimmingPools.SportPool(use_idealHeatExchanger=false),
    AixLib.DataBase.Pools.TypesOfIndoorSwimmingPools.SportPool(use_idealHeatExchanger=false),
    AixLib.DataBase.Pools.TypesOfIndoorSwimmingPools.SportPool(use_idealHeatExchanger=false)});
end SwimmingHallMultiplePools;
