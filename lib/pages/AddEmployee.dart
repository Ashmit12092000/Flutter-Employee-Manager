// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'package:date_time_picker/date_time_picker.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:employee_manager_zylu_task/Adapter/EmployeeAdapter.dart';
import 'package:employee_manager_zylu_task/Model/EmplyeeModel.dart';
import 'package:flutter/material.dart';

import '../Utils/AppColors.dart';
import '../Utils/AppRoute.dart';
import '../Utils/WidgetHelper.dart';

class AddEmployeePage extends StatefulWidget {
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployeePage> {
  var _empName = TextEditingController();
  var _empPhone = TextEditingController();
  var _ageController = TextEditingController();
  var activeController = TextEditingController();
  var employeeDbService = EmployeeAdapter();
  int maxLines = 5;
  String? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Employee',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blueAppColor,
          ),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.grey,
              ),
              onPressed: () => {
                setState(() => {Navigator.pop(context)})
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ignore: prefer_const_constructors
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Employee Name",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 20, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: _empName,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Employee Name"),
              ),
            ),
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Mobile Number",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 20, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: _empPhone,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Write the Answer"),
              ),
            ),
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Age",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 20, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: _ageController,
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter the age"),
              ),
            ),
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Is Active?",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 20, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: activeController,
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter 1 for active and 0 for inactive"),
              ),
            ),
            SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Date of Joining",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 20, 52),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            DateTimePicker(
              initialValue: "",
              type: DateTimePickerType.date,
              dateLabelText: 'Select Date',
              firstDate: DateTime(1950),
              lastDate: DateTime.now().add(Duration(
                  days: 365)), // This will add one year from current date
              validator: (value) {
                return null;
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedDate = value;
                  });
                }
              },
              // We can also use onSaved
              onSaved: (value) {
                setState(() {
                  if (value!.isNotEmpty) {
                  _selectedDate = value;
                }
                });
                
              },
            ),
            SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      String formattedDate =
                          DateTime.parse(_selectedDate!).toIso8601String();
                      var _employee = EmployeeModel();
                      _employee.empName = _empName.text;
                      _employee.empPhone = _empPhone.text;
                      _employee.doj =
                          formattedDate;
                      _employee.isActive = activeController.text;
                      _employee.age = _ageController.text;
                      var result = await employeeDbService.insert(_employee);
                      if (result != null) {
                        WidgetHelper.showToast(
                            "Employee added successfully  : " +
                                result.toString());
                        Navigator.popAndPushNamed(
                          context,
                          AppRoute.emprout,
                        );
                      } else {
                        WidgetHelper.showToast("Something Went wrong !!");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 32, 20, 52),
                    ),
                    child: Text("Save",
                        style: TextStyle(
                            color: Color.fromARGB(255, 244, 243, 245),
                            fontWeight: FontWeight.bold,
                            fontSize: 20))

                    /*:
                        Text("Update Question",style: TextStyle(
                        color: Color.fromARGB(255, 244, 243, 245),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,)
                        */
                    ),
              ),
            )
          ],
        ),
      )),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
