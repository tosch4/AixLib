within AixLib.Airflow.AirHandlingUnit;
model decentralAHU "Building of decentral air handling unit"
  Fluid.Movers.FlowControlled_m_flow SUP
    annotation (Placement(transformation(extent={{48,12},{64,26}})));
  Fluid.Movers.FlowControlled_m_flow EHA annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={-47,21})));
  Fluid.HeatPumps.Carnot_y heaPum
    annotation (Placement(transformation(extent={{-18,48},{14,80}})));
  Fluid.HeatExchangers.ConstantEffectiveness HRS(eps=0.68)
    annotation (Placement(transformation(extent={{-18,-28},{12,4}})));
  Fluid.Actuators.Valves.ThreeWayLinear val
    annotation (Placement(transformation(extent={{-54,-62},{-34,-42}})));
  Fluid.Actuators.Valves.ThreeWayLinear val1
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Fluid.Sources.Outside ODA(nPorts=2)
    annotation (Placement(transformation(extent={{-114,-18},{-94,2}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    annotation (Placement(transformation(extent={{96,10},{116,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    annotation (Placement(transformation(extent={{96,-62},{116,-42}})));
equation
  connect(val.port_1, ODA.ports[1]) annotation (Line(points={{-54,-52},{-80,-52},
          {-80,-6},{-94,-6}}, color={0,127,255}));
  connect(EHA.port_b, ODA.ports[2]) annotation (Line(points={{-54,21},{-66,21},
          {-66,16},{-84,16},{-84,-10},{-94,-10}}, color={0,127,255}));
  connect(val.port_2, HRS.port_a1) annotation (Line(points={{-34,-52},{-26,-52},
          {-26,-2.4},{-18,-2.4}}, color={0,127,255}));
  connect(HRS.port_b1, val1.port_1) annotation (Line(points={{12,-2.4},{16,-2.4},
          {16,-2},{18,-2},{18,20},{20,20}}, color={0,127,255}));
  connect(val1.port_2, SUP.port_a) annotation (Line(points={{40,20},{44,20},{44,
          19},{48,19}}, color={0,127,255}));
  connect(port_a, HRS.port_a2) annotation (Line(points={{106,-52},{60,-52},{60,
          -21.6},{12,-21.6}}, color={0,127,255}));
  connect(HRS.port_b2, EHA.port_a) annotation (Line(points={{-18,-21.6},{-30,
          -21.6},{-30,21},{-40,21}}, color={0,127,255}));
  connect(val.port_3, val1.port_3)
    annotation (Line(points={{-44,-62},{30,-62},{30,10}}, color={0,127,255}));
  connect(SUP.port_b, heaPum.port_a1) annotation (Line(points={{64,19},{72,19},
          {72,88},{-38,88},{-38,73.6},{-18,73.6}}, color={0,127,255}));
  connect(heaPum.port_b1, port_b) annotation (Line(points={{14,73.6},{48,73.6},
          {48,74},{84,74},{84,20},{106,20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end decentralAHU;
