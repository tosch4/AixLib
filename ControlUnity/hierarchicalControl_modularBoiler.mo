within ControlUnity;
model hierarchicalControl_modularBoiler
  parameter Real PLRmin=0.15;
  parameter Boolean use_advancedControl=true "Selection between two position control and flow temperature control, if true=flow temperature control is active";

  Modelica.Blocks.Interfaces.RealInput Tin
    "Boiler Temperature; for emergency stop"
    annotation (Placement(transformation(extent={{-122,52},{-82,92}})));
  Modelica.Blocks.Interfaces.RealOutput PLRset
    annotation (Placement(transformation(extent={{90,44},{110,64}})));
  Modelica.Blocks.Interfaces.RealInput PLRin
    annotation (Placement(transformation(extent={{-118,-26},{-78,14}})));
    //Two position controller

//Flow temperature control

   flowTemperatureController.flowTemperatureControl_heatingCurve
    flowTemperatureControl_heatingCurve
    annotation (Placement(transformation(extent={{34,-34},{54,-14}})));


  NotAusschalter_modularBoiler notAusschalter_modularBoiler
    annotation (Placement(transformation(extent={{-60,26},{-40,46}})));
 Modelica.Blocks.Interfaces.RealInput Tamb if use_advancedControl
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-120,2},{-80,42}})));

  /// Emergency switch and mass flow control
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{44,-84},{64,-64}})));
  Modelica.Blocks.Interfaces.RealInput mFlow_rel
    annotation (Placement(transformation(extent={{-120,-102},{-80,-62}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=PLRmin)
    annotation (Placement(transformation(extent={{12,-76},{32,-56}})));

  Modelica.Blocks.Interfaces.RealOutput mFlow_relB
    annotation (Placement(transformation(extent={{92,-84},{112,-64}})));
  Modelica.Blocks.Sources.RealExpression realExpression1
    annotation (Placement(transformation(extent={{-70,-58},{-50,-38}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=PLRmin)
    annotation (Placement(transformation(extent={{-60,-28},{-46,-14}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-28,-36},{-12,-20}})));






  twoPositionController.BaseClass.twoPositionControllerCal.twoPositionController_layers
    twoPositionController_layers(n=n)
    annotation (Placement(transformation(extent={{22,40},{42,60}})));
  parameter Integer n=3 "Number of layers in the buffer storage";
  Modelica.Blocks.Interfaces.RealInput TLayers[n]
    "Different temperatures of  layers of  buffer storage; 1 is first layer, n ist last layer"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={12,100})));
equation
  //Advanced or simple control
  connect(Tin, notAusschalter_modularBoiler.T_ein) annotation (Line(points={{-102,
          72},{-82,72},{-82,41.2},{-60,41.2}}, color={0,0,127}));

    if use_advancedControl then
    else
    end if;

  connect(mFlow_rel, switch1.u3)
    annotation (Line(points={{-100,-82},{42,-82}}, color={0,0,127}));
  connect(realExpression.y, switch1.u1)
    annotation (Line(points={{33,-66},{42,-66}}, color={0,0,127}));

  connect(switch1.y, mFlow_relB)
    annotation (Line(points={{65,-74},{102,-74}}, color={0,0,127}));
  connect(lessThreshold.y, switch2.u2) annotation (Line(points={{-45.3,-21},{-36.65,
          -21},{-36.65,-28},{-29.6,-28}}, color={255,0,255}));
  connect(lessThreshold.y, switch1.u2) annotation (Line(points={{-45.3,-21},{-36,
          -21},{-36,-74},{42,-74}}, color={255,0,255}));
  connect(PLRin, lessThreshold.u) annotation (Line(points={{-98,-6},{-70,-6},{-70,
          -21},{-61.4,-21}}, color={0,0,127}));
  connect(switch2.y, notAusschalter_modularBoiler.PLR_ein) annotation (Line(
        points={{-11.2,-28},{-10,-28},{-10,12},{-64,12},{-64,34.8},{-60,34.8}},
        color={0,0,127}));
  connect(PLRin, switch2.u3) annotation (Line(points={{-98,-6},{-70,-6},{-70,-34.4},
          {-29.6,-34.4}}, color={0,0,127}));
  connect(realExpression1.y, switch2.u1) annotation (Line(points={{-49,-48},{-32,
          -48},{-32,-21.6},{-29.6,-21.6}}, color={0,0,127}));


  connect(notAusschalter_modularBoiler.PLR_set, twoPositionController_layers.PLRin)
    annotation (Line(points={{-40,39},{-12,39},{-12,59},{22,59}}, color={0,0,127}));
  connect(twoPositionController_layers.PLRset, PLRset) annotation (Line(points={{43,55.2},
          {66.5,55.2},{66.5,54},{100,54}},           color={0,0,127}));
  connect(TLayers, twoPositionController_layers.TLayers)
    annotation (Line(points={{12,100},{12,53.6},{22,53.6}}, color={0,0,127}));
end hierarchicalControl_modularBoiler;
