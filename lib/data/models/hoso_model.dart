class HosoRelative {
  final String relation;
  final String fullName;
  final String birthYear;
  final String cccd;
  final String bhyt;

  const HosoRelative({
    required this.relation,
    required this.fullName,
    required this.birthYear,
    required this.cccd,
    required this.bhyt,
  });
}

class HosoTransfer {
  final String content;
  final String date;

  const HosoTransfer({
    required this.content,
    required this.date,
  });
}

class HosoDegree {
  final String major;
  final String place;
  final String level;
  final String date;
  final String attachmentName;

  const HosoDegree({
    required this.major,
    required this.place,
    required this.level,
    required this.date,
    required this.attachmentName,
  });
}

class HosoCertificate {
  final String name;
  final String date;
  final String attachmentName;

  const HosoCertificate({
    required this.name,
    required this.date,
    required this.attachmentName,
  });
}

class HosoData {
  final String avatarUrl;
  final String fullName;
  final String birthYear;
  final String gender;
  final String maritalStatus;
  final List<HosoRelative> relatives;
  final HosoTransfer transfer;
  final String currentAddress;
  final String permanentAddress;
  final String bhytNumber;
  final String bhytRegisterPlace;
  final String bhxhNumber;
  final String bankNumber;
  final String bankAccountName;
  final String bankName;
  final String taxCode;
  final String cccdNumber;
  final String cccdIssueDate;
  final String cccdIssuePlace;
  final String cchnNumber;
  final String cchnIssueDate;
  final String cchnIssuePlace;
  final String cchnDegree;
  final String cchnScope;
  final String cchnFile;
  final String cchnPlannedDate;
  final String titleName;
  final String titleCouncil;
  final String titleIssueDate;
  final List<HosoDegree> degrees;
  final List<HosoCertificate> certificates;
  final String continuousTrainingHours;

  const HosoData({
    required this.avatarUrl,
    required this.fullName,
    required this.birthYear,
    required this.gender,
    required this.maritalStatus,
    required this.relatives,
    required this.transfer,
    required this.currentAddress,
    required this.permanentAddress,
    required this.bhytNumber,
    required this.bhytRegisterPlace,
    required this.bhxhNumber,
    required this.bankNumber,
    required this.bankAccountName,
    required this.bankName,
    required this.taxCode,
    required this.cccdNumber,
    required this.cccdIssueDate,
    required this.cccdIssuePlace,
    required this.cchnNumber,
    required this.cchnIssueDate,
    required this.cchnIssuePlace,
    required this.cchnDegree,
    required this.cchnScope,
    required this.cchnFile,
    required this.cchnPlannedDate,
    required this.titleName,
    required this.titleCouncil,
    required this.titleIssueDate,
    required this.degrees,
    required this.certificates,
    required this.continuousTrainingHours,
  });
}
