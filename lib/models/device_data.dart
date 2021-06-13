class DeviceData {
  int? id;
  String? value;
  String? createdAt;
  DateTime? createdAtDate;

  DeviceData(int? id, String value, String createdAt) {
    this.id = id;
    this.value = value;
    this.createdAt = createdAt;
    createdAtDate = DateTime.parse(createdAt);
  }

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    var deviceData = DeviceData(json['id'], json['value'], json['created_at']);

    return deviceData;
  }
}
