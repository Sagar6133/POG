class AlarmList {
  String selectedNeartestLocation;
  String exartLocation;
  String problemOfTheVehicle;
  String vehicleNumber;
  String nameOfTheDriver;
  String driverContactNumber;
  String vehicleType;
  String ownerNumber;
  bool isPaid;
  String createdDate;
  double amountToBePaid;
  bool ammountAssigned;
  String paymentId;

  AlarmList(
    this.selectedNeartestLocation,
    this.problemOfTheVehicle,
    this.vehicleNumber,
    this.nameOfTheDriver,
    this.driverContactNumber,
    this.vehicleType,
    this.ownerNumber,
    this.isPaid,
    this.createdDate,
    this.amountToBePaid,
    this.ammountAssigned,
    this.paymentId,
    this.exartLocation,
  );
}
