// ignore_for_file: prefer_const_declarations, non_constant_identifier_names

import 'package:employee_manager_zylu_task/Model/EmplyeeModel.dart';

import '../Database/DBHelper.dart';

class EmployeeAdapter {
  late DBHelper _repository;
  EmployeeModel questionModel = EmployeeModel();
  EmployeeAdapter() {
    _repository = DBHelper();
  }

  //insert Question
  insert(EmployeeModel ques) async {
    createTable();
    return await _repository.insert(
        EmployeeModel.KEY_EMPLOYEE_TABLE_NAME, ques.toMap());
  }

  //getAllQuestions
  getList() async {
    return await _repository.getList(EmployeeModel.KEY_EMPLOYEE_TABLE_NAME);
  }

  getListById(organisationId) async {
    List results = await _repository.getListById(
        EmployeeModel.KEY_EMPLOYEE_TABLE_NAME, organisationId);
    List items = [];
    results.forEach((element) {
      items.add(EmployeeModel.fromMap(element));
    });
    return results;
  }

  getEmployeeByID(questionId) async {
    return await _repository.getData(
        EmployeeModel.KEY_EMPLOYEE_TABLE_NAME, questionId);
  }

  //Edit Question
  Update(question) async {
    return await _repository.update(
        EmployeeModel.KEY_EMPLOYEE_TABLE_NAME, question.toMap());
  }

  //delete Question
  delete(questionId) async {
    return await _repository.deleteDataById(
        EmployeeModel.KEY_EMPLOYEE_TABLE_NAME, questionId);
  }

  createTable() async {
    return await _repository.createTable(EmployeeModel.KEY_EMPLOYEE_TABLE_NAME);
  }
}
