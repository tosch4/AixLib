within AixLib.Airflow.FacadeVentilationUnit.DataBase;
record FanBaseRecord
  extends Modelica.Icons.Record;


  parameter Real [:, :] volumeFlow
    "Correlates the relative input signal and a volume flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={6,10})));
end FanBaseRecord;
