class DeviceData {
  int? id;
  String? value;
  String? createdAt;
  DateTime? createdAtDate;

  DeviceData(int id, String value, String createdAt) {
    this.id = id;
    this.value = value;
    this.createdAt = createdAt;
    this.createdAtDate = DateTime.parse(createdAt);
  }

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    print("deviceData ${json["created_at"]}");

    DeviceData deviceData =
        new DeviceData(json["id"], json["value"], json["created_at"]);

    return deviceData;
  }
}
