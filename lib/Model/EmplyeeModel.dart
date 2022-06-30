// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, prefer_collection_literals, unnecessary_null_in_if_null_operators

class EmployeeModel {
  //CONSTANTS
  static final String KEY_EMPLOYEE_TABLE_NAME = "EmployeeTable";
  //int? mQuestionId;
  int? empid;
  String? empName;
  String? empPhone;
  String? doj;
  String? isActive;
  String? age;
  EmployeeModel() {}

  //ToMap()
  toMap() {
    var mapping = Map<String, dynamic>();
    mapping['EMPID'] = empid;
    mapping['EMPNAME'] = empName!;
    mapping['EMPMOBILE'] = empPhone!;
    mapping['DOJ'] =doj!;
    mapping['AGE'] =age!;
    mapping['isActive'] =isActive!;
    return mapping;
  }

  EmployeeModel.fromMap(dynamic obj) {
    this.empid = obj['EMPID'];
    this.empName = obj['EMPNAME'];
    this.empPhone = obj['EMPMOBILE'];
    this.doj = obj['DOJ'];
    this.age = obj['AGE'];
    isActive = obj['isActive'];
  }
}
