within AixLib.Fluid.HeatExchangers.ActiveWalls.UnderfloorHeating.BaseClasses.Walls;
model InnerWall
  ThermalZones.ReducedOrder.RC.BaseClasses.InteriorWall
                           intWallRC(
    final n=nInt,
    final RInt=RInt,
    final CInt=CInt,
    final T_start=T_start) if AInt > 0 "RC-element for interior walls"
    annotation (Placement(transformation(extent={{6,18},{26,40}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_conv "interior port"
    annotation (Placement(transformation(extent={{-108,16},{-88,36}}),
        iconTransformation(extent={{-14,-108},{6,-88}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_transfer annotation
    (Placement(transformation(extent={{-18,-110},{2,-90}}), iconTransformation(
          extent={{-114,-10},{-94,10}})));
protected
  Modelica.Thermal.HeatTransfer.Components.Convection convIntWall(dT(start=0))
    if                                                               AInt > 0
    "Convective heat transfer of interior walls"
    annotation (Placement(transformation(extent={{-28,36},{-48,16}})));
  Modelica.Blocks.Sources.Constant hConIntWall(k=AInt*hConInt) if AInt > 0
    "Coefficient of convective heat transfer for interior walls"
    annotation (Placement(transformation(
      extent={{5,-5},{-5,5}},
      rotation=-90,
      origin={-38,5})));
equation
  connect(convIntWall.solid,intWallRC. port_a)
    annotation (Line(
    points={{-28,26},{-12,26},{-12,28},{6,28}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(hConIntWall.y,convIntWall. Gc)
    annotation (Line(points={{-38,10.5},{-38,16}},       color={0,0,127}));
  connect(port_conv, convIntWall.fluid)
    annotation (Line(points={{-98,26},{-48,26}}, color={191,0,0}));
  connect(port_transfer, intWallRC.port_a)
    annotation (Line(points={{-8,-100},{-8,28},{6,28}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                           Rectangle(extent={{-90,58},{-38,24}},
                          fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
   Rectangle(extent={{-32,58},{22,24}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{28,58},{82,24}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-4,18},{50,-16}},     fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-64,18},{-10,-16}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-90,-22},{-38,-56}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-32,-22},{22,-56}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{28,-22},{82,-56}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-64,-62},{-10,-96}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-4,-62},{50,-96}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-64,98},{-10,64}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-4,98},{50,64}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{56,-62},{82,-96}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{56,18},{82,-16}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{56,98},{82,64}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-90,-62},{-70,-96}},     fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-90,18},{-70,-16}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-90,98},{-70,64}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
   Line(points={{-94,-2},{-6,-2}},
                                 color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None), Rectangle(extent={{-70,10},{-22,-12}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Line(points={{-6,-2},{-6,-34}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
   Line(points={{-23,-34},{11,-34}},      pattern = LinePattern.None,
   thickness = 0.5, smooth = Smooth.None), Line(points={{-23,-46},{11,-46}},
   pattern = LinePattern.None, thickness = 0.5, smooth = Smooth.None), Text(
    extent={{-94,140},{86,102}},      lineColor = {0, 0, 255}, textString = "%name"),
   Line(points={{14,-34},{-24,-34}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{10,-46},{-19,-46}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={
  Polygon(
    points={{-60,48},{54,48},{54,-14},{-36,-14},{-38,-14},{-60,-14},{-60,48}},
    lineColor={0,0,255},
    smooth=Smooth.None,
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-3,1},{48,-16}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Interior Walls")}));
end InnerWall;
