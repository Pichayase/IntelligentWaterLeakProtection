class ViewLogModel {
  String? id;
  String? val;
  String? val2;
  String? date;
  String? time;

  ViewLogModel({this.id, this.val, this.val2, this.date, this.time});

  ViewLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    val = json['val'];
    val2 = json['val2'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['val'] = val;
    data['val2'] = val2;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
