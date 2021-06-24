within AixLib.Fluid.HeatExchangers.ActiveWalls.UnderfloorHeating.Examples.ROM_UFH;
model Wall_UFH
  extends Modelica.Icons.Example;
  ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall
                           intWallRC(
    final n=nInt,
    final RInt=RInt,
    final CInt=CInt,
    final T_start=T_start) if AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{6,40},{26,62}})));
protected
  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall(dT(start=0))
    if                                                               AInt > 0
    "Convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{-28,60},{-48,40}})));
  Modelica.Blocks.Sources.Constant hConIntWall(k=AInt*hConInt) if AInt > 0
    "Coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
      extent={{5,-5},{-5,5}},
      rotation=-90,
      origin={-38,29})));
equation
  connect(convIntWall.solid,intWallRC. port_a)
    annotation (Line(
    points={{-28,50},{6,50}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(hConIntWall.y,convIntWall. Gc)
    annotation (Line(points={{-38,34.5},{-38,40}},       color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
  Polygon(
    points={{-60,72},{54,72},{54,10},{-36,10},{-38,10},{-60,10},{-60,72}},
    lineColor={0,0,255},
    smooth=Smooth.None,
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-3,25},{48,8}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Interior Walls")}));
end Wall_UFH;
