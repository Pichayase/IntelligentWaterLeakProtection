class Configuration {
  int? valveStatus;
  int? functionMode;
  int? alertStatus;

  Configuration({this.valveStatus, this.functionMode, this.alertStatus});

  Configuration.fromJson(Map<String, dynamic> json) {
    valveStatus = json['ValveStatus'];
    functionMode = json['FunctionMode'];
    alertStatus = json['AlertStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ValveStatus'] = valveStatus;
    data['FunctionMode'] = functionMode;
    data['AlertStatus'] = alertStatus;
    return data;
  }
}
