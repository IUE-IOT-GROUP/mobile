class DeviceData {
  String? id;
  String? value;
  String? createdAt;
  DateTime? createdAtDate;

  DeviceData(String? id, String value, String createdAt) {
    this.id = id;
    this.value = value;
    this.createdAt = createdAt;
    createdAtDate = DateTime.parse(createdAt);
  }

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    var deviceData = DeviceData(json['id'], json['value'], json['created_at']);
    print('1666 $deviceData');
    return deviceData;
  }
}
