within AixLib.Fluid.HeatExchangers.ActiveWalls.UnderfloorHeating.BaseClasses.Walls;
model OuterWall
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "interior port"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
    iconTransformation(extent={{-108,-12},{-88,8}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "exterior port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
    iconTransformation(extent={{92,-12},{112,8}})));
  ThermalZones.ReducedOrder.RC.BaseClasses.ExteriorWall
                           extWallRC(
    final n=nExt,
    final RExt=RExt,
    final CExt=CExt,
    final RExtRem=RExtRem,
    final T_start=T_start) if ATotExt > 0 "RC-element for exterior walls"
    annotation (Placement(transformation(extent={{-14,-10},{-34,12}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_conv "interior port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-108,-12},{-88,8}})));
protected
  Modelica.Thermal.HeatTransfer.Components.Convection convExtWall(dT(start=0))
    if                                                               ATotExt > 0
    "Convective heat transfer of exterior walls"
    annotation (Placement(transformation(extent={{30,10},{50,-10}})));
  Modelica.Blocks.Sources.Constant hConExtWall_const(final k=ATotExt*hConExt)
    if                        ATotExt > 0
    "Coefficient of convective heat transfer for exterior walls"
    annotation (Placement(transformation(
    extent={{5,-5},{-5,5}},
    rotation=-90,
    origin={40,-21})));
equation
  connect(extWallRC.port_a,convExtWall. solid)
    annotation (Line(
    points={{-14,0},{30,0}},
    color={191,0,0},
    smooth=Smooth.None));
  connect(hConExtWall_const.y,convExtWall. Gc)
    annotation (Line(points={{40,-15.5},{40,-10}},
    color={0,0,127}));
  connect(extWallRC.port_b, port_a)
    annotation (Line(points={{-34,0},{-100,0}}, color={191,0,0}));
  connect(port_b, convExtWall.solid) annotation (Line(points={{100,0},{76,0},{
          76,50},{0,50},{0,0},{30,0}}, color={191,0,0}));
  connect(convExtWall.fluid, port_conv) annotation (Line(points={{50,0},{66,0},
          {66,-80},{0,-80},{0,-100}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Rectangle(extent={{-84,58},{-32,24}},
   fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-26,58},{28,24}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{34,58},{88,24}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,18},{56,-16}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,18},{-4,-16}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-22},{-32,-56}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-26,-22},{28,-56}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{34,-22},{88,-56}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,-62},{-4,-96}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,-62},{56,-96}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,98},{-4,64}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,98},{56,64}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,-62},{88,-94}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,18},{88,-16}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,98},{88,64}},       fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-62},{-64,-96}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,18},{-64,-16}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,98},{-64,64}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
   Line(points={{-88,-2},{92,-2}},    color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None), Rectangle(extent={{-72,10},{-24,-12}},
   lineColor = {0, 0, 0}, lineThickness = 0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{30,10},{78,-12}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Line(points={{1,-2},{1,-34}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
   Line(points={{-16,-34},{18,-34}},      pattern = LinePattern.None,
   thickness = 0.5, smooth = Smooth.None), Line(points={{-16,-46},{18,-46}},
   pattern = LinePattern.None, thickness = 0.5, smooth = Smooth.None),
   Text(extent={{-88,140},{92,102}},      lineColor = {0, 0, 255},
   textString = "%name"),
   Line(points={{20,-34},{-18,-34}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{16,-46},{-13,-46}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={
  Rectangle(
    extent={{-60,20},{58,-34}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid),
  Text(
    extent={{-57,-19},{-2,-36}},
    lineColor={0,0,255},
    fillColor={215,215,215},
    fillPattern=FillPattern.Solid,
    textString="Exterior Walls")}));
end OuterWall;
