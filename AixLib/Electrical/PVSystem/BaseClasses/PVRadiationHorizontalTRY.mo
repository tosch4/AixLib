within AixLib.Electrical.PVSystem.BaseClasses;
model PVRadiationHorizontalTRY
 "PV radiation and absorptance model - input: diffuse and beam irradiance on horizontal plane"

 parameter Real lat(final quantity = "Angle",
   final unit = "rad",
   displayUnit = "deg") "Latitude"
   annotation (Dialog(group="Location and orientation"));
 parameter Real lon(final quantity = "Angle",
   final unit = "rad",
   displayUnit = "deg") "Longitude"
   annotation (Dialog(group="Location and orientation"));
 parameter Real  alt(final quantity="Length", final unit="m")
   "Site altitude in Meters, default= 1"
   annotation (Dialog(group="Location and orientation"));
 parameter Real til(final quantity = "Angle",
   final unit = "rad",
   displayUnit = "deg")
   "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof"
   annotation (Dialog(group="Location and orientation"));
 parameter Real  azi(final quantity = "Angle",
   final unit = "rad",
   displayUnit = "deg")
   "Module surface azimuth. azi=-90 degree if normal of surface outward unit points towards east; azi=0 if it points towards south"
   annotation (Dialog(group="Location and orientation"));
 parameter Real timZon(final quantity="Time",
   final unit="s", displayUnit="h")
   "Time zone in seconds relative to GMT"
   annotation (Dialog(group="Location and orientation"));

 parameter Real groRef(final unit="1")
   "Ground refelctance"
   annotation (Dialog(tab="Irradiation"));

// Air mass parameters for mono-SI which are also applicable to poly-SI cells
// Source: De Soto et al., "Improvement and validation of a model
// for photovoltaic array performance" In: Solar Energy 80 (2006)
  parameter Real b_0=0.935823 "Air mass parameter for mono- and poly-SI" annotation (Dialog(tab="Irradiation"));
  parameter Real b_1=0.054289 "Air mass parameter for mono- and poly-SI" annotation (Dialog(tab="Irradiation"));
  parameter Real b_2=-0.008677 "Air mass parameter for mono- and poly-SI" annotation (Dialog(tab="Irradiation"));
  parameter Real b_3=0.000527 "Air mass parameter for mono- and poly-SI" annotation (Dialog(tab="Irradiation"));
  parameter Real b_4=-0.000011 "Air mass parameter for mono- and poly-SI" annotation (Dialog(tab="Irradiation"));

  parameter Real glaExtCoe(final unit="1/m") = 4
  "Glazing extinction coefficient for glass";

  parameter Real glaThi(final unit="m") = 0.002
  "Glazing thickness for most PV cell panels";

  parameter Real refInd(final unit="1", min=0) = 1.526
  "Effective index of refraction of the cell cover (glass)";

  parameter Real tau_0(final unit="1", min=0)=
   exp(-(glaExtCoe*glaThi))*(1 - ((refInd - 1)/(refInd + 1))
  ^2) "Transmittance at standard conditions (incAng=refAng=0)";

  final parameter Real radTil0(final quantity="Irradiance",
  final unit= "W/m2") = 1000 "total solar radiation on the horizontal surface under standard conditions" annotation (Dialog(tab="Irradiation"));

  final parameter Real G_sc(final quantity="Irradiance",
  final unit = "W/m2") = 1376 "Solar constant" annotation (Dialog(tab="Irradiation"));

 Modelica.Blocks.Interfaces.RealInput radHorBea(final quantity="Irradiance",
   final unit= "W/m2")
   "Beam solar radiation on the horizontal surface"
   annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

 Modelica.Blocks.Interfaces.RealInput radHorDif(final quantity="Irradiance",
   final unit= "W/m2")
   "Diffuse solar radiation on the horizontal surface"
   annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

 Real cloTim(final quantity="Time",
   final unit="s", displayUnit="h")
   "Local clock time";
 Real nDay(final quantity="Time",final unit="s")
    "Day number with units of seconds";

 Real airMas(final unit="1", min=0)
  "Air mass";
 Real airMasMod(final unit="1", min=0)
  "Air mass modifier";
 Modelica.SIunits.Angle incAngGro
  "Incidence angle for ground reflection";
 Modelica.SIunits.Angle incAngDif
  "Incidence angle for diffuse radiation";
 Real incAngMod(final unit="1", min=0)
  "Incidence angle modifier";
 Real incAngModGro(final unit="1", min=0)
  "Incidence angle modifier for ground refelction";
 Real incAngModDif(final unit="1", min=0)
  "Incidence angle modifier for diffuse radiation";
 Modelica.SIunits.Angle refAng
  "Angle of refraction";
 Modelica.SIunits.Angle refAngGro
  "Angle of refraction for ground reflection";
 Modelica.SIunits.Angle refAngDif
  "Angle of refraction for diffuse irradiation";
 Real tau(final unit="1", min=0)
  "Transmittance of the cover system";
 Real tau_ground(final unit="1", min=0)
  "Transmittance of the cover system for ground reflection";
 Real tau_diff(final unit="1", min=0)
  "Transmittance of the cover system for diffuse radiation";
 Real R_b(final unit="1", min=0)
   "Ratio of irradiance on tilted surface to horizontal surface";
 Real radHor(final quantity="Irradiance",
   final unit= "W/m2")
   "Total solar irradiance on the horizontal surface";
 Modelica.SIunits.Angle zen
  "Zenith angle";
 AixLib.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    "Solar hour angle";
 AixLib.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
    timZon=timZon,
    lon=lon)
    "Block that computes the local civil time";
 AixLib.BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
    "Block that computes the solar time";
 AixLib.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    "Block that computes the equation of time";
 AixLib.BoundaryConditions.SolarGeometry.BaseClasses.DeclinationSpencer decAng
    "Declination angle";
 AixLib.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngleDuffie incAng(
   azi=azi,
   til=til,
   lat=lat) "Incidence angle";
 AixLib.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zenAng(
   lat=lat) "Zenith angle";
 Utilities.Time.ModelTime modTim "Block that outputs simulation time";


 Modelica.Blocks.Interfaces.RealOutput radTil(final quantity="Irradiance",
   final unit= "W/m2")
   "Total solar radiation on the tilted surface"
   annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

 Modelica.Blocks.Interfaces.RealOutput absRadRat(final unit= "1", min=0)
   "Ratio of absorbed radiation under operating conditions to standard conditions"
   annotation (Placement(transformation(extent={{100,50},{120,70}})));

equation

 connect(solTim.solTim, solHouAng.solTim);

 connect(locTim.locTim, solTim.locTim);

 connect(eqnTim.eqnTim, solTim.equTim);

 connect(decAng.decAng, incAng.decAng);

 connect(solHouAng.solHouAng, incAng.solHouAng);

 connect(decAng.decAng, zenAng.decAng);

 connect(solHouAng.solHouAng, zenAng.solHouAng);

 nDay = floor(modTim.y/86400)*86400
  "Zero-based day number in seconds (January 1=0, January 2=86400)";

 cloTim= modTim.y-nDay;

 eqnTim.nDay= nDay;

 locTim.cloTim=cloTim;

 decAng.nDay= nDay;

 zen = if zenAng.zen <= Modelica.Constants.pi/2 then
 zenAng.zen
 else
 Modelica.Constants.pi/2
 "Restriction for zenith angle";



  refAng = if (incAng.incAng >= 0.0001 and incAng.incAng <= Modelica.Constants.pi
  /2*0.999) then asin(sin(incAng.incAng)/refInd) else
  0;

  refAngGro = if (incAngGro >= 0.0001 and incAngGro <= Modelica.Constants.pi/2*
  0.999) then asin(sin(incAngGro)/refInd) else
  0;

  refAngDif = if (incAngDif >= 0.0001 and incAngDif <= Modelica.Constants.pi/2*
  0.999) then asin(sin(incAngDif)/refInd) else
  0;

  tau = if (incAng.incAng >= 0.0001 and incAng.incAng <= Modelica.Constants.pi/
  2*0.999 and refAng >= 0.0001) then exp(-(glaExtCoe*glaThi/cos(refAng)))*(1
  - 0.5*((sin(refAng - incAng.incAng)^2)/(sin(refAng + incAng.incAng)^2) + (
  tan(refAng - incAng.incAng)^2)/(tan(refAng + incAng.incAng)^2))) else
  0;

  tau_ground = if (incAngGro >= 0.0001 and refAngGro >= 0.0001) then exp(-(
  glaExtCoe*glaThi/cos(refAngGro)))*(1 - 0.5*((sin(refAngGro - incAngGro)^2)/
  (sin(refAngGro + incAngGro)^2) + (tan(refAngGro - incAngGro)^2)/(tan(
  refAngGro + incAngGro)^2))) else
  0;

  tau_diff = if (incAngDif >= 0.0001 and refAngDif >= 0.0001) then exp(-(
  glaExtCoe*glaThi/cos(refAngDif)))*(1 - 0.5*((sin(refAngDif - incAngDif)^2)/
  (sin(refAngDif + incAngDif)^2) + (tan(refAngDif - incAngDif)^2)/(tan(
  refAngDif + incAngDif)^2))) else
  0;


  incAngMod = tau/tau_0;

  incAngModGro = tau_ground/tau_0;

  incAngModDif = tau_diff/tau_0;


  airMasMod = if (b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(
  airMas^3) + b_4*(airMas^4)) <= 0 then
  0 else
  b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(airMas^3) + b_4*(airMas^4);



  airMas = exp(-0.0001184*alt)/(cos(zen) + 0.5057*(96.080 - zen*
  180/Modelica.Constants.pi)^(-1.634));

  incAngGro = (90 - 0.5788*til*180/Modelica.Constants.pi + 0.002693*(til*180/
  Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;

  incAngDif = (59.7 - 0.1388*til*180/Modelica.Constants.pi + 0.001497*(til*180/
  Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;



  R_b = if ((zen >= Modelica.Constants.pi/2*0.999) or (cos(incAng.incAng)
  > cos(zen)*4)) then 4 else (cos(incAng.incAng)/cos(zen));


  radHor = radHorBea + radHorDif;

  radTil = if radHor <= 0.1 then 0 else radHorBea*R_b + radHorDif*(0.5*(1 + cos(
  til)*(1 + (1 - (radHorDif/radHor)^2)*sin(til/2)^3)*(1 + (1 - (radHorDif/
  radHor)^2)*(cos(incAng.incAng)^2)*(cos(til)^3)))) + radHor*groRef*(1 - cos(
  til))/2;



  absRadRat = if (radHor <=0.1) then 0
  else
  min(airMasMod*(radHorBea/radTil0*R_b*incAngMod
  +radHorDif/radTil0*incAngModDif*(0.5*(1+cos(til)*(1+(1-(radHorDif/radHor)^2)*sin(til/2)^3)*(1+(1-(radHorDif/radHor)^2)*(cos(incAng.incAng)^2)*(cos(til)^3))))
  +radHor/radTil0*groRef*incAngModGro*(1-cos(til))/2),1);


  annotation (Icon(graphics={   Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://AixLib/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/IncidenceAngle.png")}),
              Documentation(info="<html>
<h4><span style=\"color: #008000\">Overview</span></h4>
<p>Model for determining Irradiance and absorptance ratio for PV modules - input: diffuse and beam irradiance on horizontal plane.</p>
<p><br><h4>Sources</h4></p>
<p>&quot;Solar engineering of thermal processes&quot;, Duffie et al. (2013); DOI 10.1002/9781118671603</p>
<p>&quot;Regenerative Energiesysteme: Technologie ; Berechnung ; Simulation&quot;, Quaschning, Volker (2015); <a href=\"https://doi.org/10.3139/9783446443334\">https://doi.org/10.3139/9783446443334</a> </p>
<p>&quot;Improvement and validation of a model for photovoltaic array performance&quot;, De Soto et al., in: Solar Energy 80 (2006); DOI 10.1016/j.solener.2005.06.010</p>
</html>"));
end PVRadiationHorizontalTRY;
