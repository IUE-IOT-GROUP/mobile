class DeviceGraphData {
  String? value;
  String? createdAt;
  DateTime? createdAtDate;

  DeviceGraphData(String value, String createdAt) {
    this.value = value;
    this.createdAt = createdAt;
    this.createdAtDate = DateTime.parse(createdAt);
  }

  factory DeviceGraphData.fromJson(Map<String, dynamic?> json) {
    DeviceGraphData deviceData =
        new DeviceGraphData(json["value"], json["created_at"]);

    return deviceData;
  }
}
