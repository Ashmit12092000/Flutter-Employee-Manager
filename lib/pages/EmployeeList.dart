// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, unnecessary_new, prefer_interpolation_to_compose_strings

import 'package:employee_manager_zylu_task/Adapter/EmployeeAdapter.dart';
import 'package:employee_manager_zylu_task/Model/EmplyeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:time_machine/time_machine.dart';

import '../Utils/AppColors.dart';
import '../Utils/AppRoute.dart';
import '../Utils/WidgetHelper.dart';

class EmployeeList extends StatefulWidget {
  @override
  // ignore: no_logic_in_create_state
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList>
    implements ActionsCallback {
  List<EmployeeModel> items = [];

  List<EmployeeModel> searchResults = [];

  int _count = 0;

  bool selected = false;

  MultiSelectController controller = new MultiSelectController();

  var searchController = TextEditingController();

  EmployeeAdapter employeeService = EmployeeAdapter();

  int? isActive;
  int workingYear = 0;

  fetchList() async {
    var employeeList = await employeeService.getList();
    items.clear();
    employeeList.forEach((employee) {
      setState(() {
        items.add(EmployeeModel.fromMap(employee));
      });
    });
  }

  int calculateExperience(String date) {
    LocalDate today = LocalDate.today();

    final d = DateTime.parse(date);
    LocalDate doj = LocalDate.dateTime(d);
    Period diff = today.periodSince(doj);
    workingYear = diff.years;
    return workingYear;
  }

  late WidgetHelper dialog;
  _EmployeeListState() {
    dialog = WidgetHelper(this);
  }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      fetchList();
    });

    super.initState();
    //employeeService.createTable();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        actions: (controller.isSelecting)
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.select_all_outlined),
                  onPressed: () {},
                ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      delete(context);
                    })
              ]
            : <Widget>[
                IconButton(
                    onPressed: refesh, icon: Icon(Icons.refresh_outlined)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: new Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        /*Navigator.push(
                              context, MaterialPageRoute(builder: (context)=> AddQuestionPageTest(mOrganizationId)));*/
                        Navigator.pushNamed(context, AppRoute.addemprout);
                      });
                    },
                  ),
                )
              ],
        backgroundColor: Color.fromARGB(255, 32, 20, 52),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: TextField(
                    // controller: textController, We will declare this later
                    onChanged: onSearchChanged,
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search_outlined,
                        color: Colors.grey,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 2)),
                    ),
                  ),
                )),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: searchController.text.isEmpty
                      ? Text(
                          "Total: " + items.length.toString(),
                          style: TextStyle(
                            color: AppColors.blueAppColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "Result: " +
                              searchResults.length.toString() +
                              " of " +
                              items.length.toString(),
                          style: TextStyle(
                            color: AppColors.blueAppColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                Icon(Icons.filter_alt_rounded),
              ],
            ),
            Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: items.isNotEmpty
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (searchController.text.isEmpty) {
                            return buildItemWidget(context, index, items);
                          } else if (items[index]
                                  .empName!
                                  .toLowerCase()
                                  .contains(searchController.text) ||
                              items[index]
                                  .empid!
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchController.text)) {
                            return buildItemWidget(context, index, items);
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Center(
                        child: Container(
                        child: Column(
                          children: [
                            SvgPicture.asset("assets/SVG/emptyItem.svg")
                          ],
                        ),
                      ))),
          ],
        ),
      ),
    );

    throw UnimplementedError();
  }

  Widget buildItemWidget(
      BuildContext context, int index, List<EmployeeModel> items) {
    _count = items.length;
    String date = items[index].doj as String;
    isActive = int.parse(items[index].isActive.toString());
    calculateExperience(date);
    WidgetHelper.showToast(date);
    WidgetHelper.showToast(isActive.toString());
    return InkWell(
      onTap: (() {
        WidgetHelper.showToast("Tapped");
        controller.deselectAll();
      }),
      child: MultiSelectItem(
        isSelecting: controller.isSelecting,
        onSelected: () {
          setState(() {
            controller.toggle(index);
            WidgetHelper.showToast(
                'Selected ${controller.selectedIndexes.length}  ' +
                    controller.selectedIndexes.toString());
          });
        },
        child: GestureDetector(
          onTapDown: _storePosition,
          onTap: () {
            //WidgetHelper.showToast("Tapped");

            setState(() {
              if (controller.isSelecting) {
                controller.deselect(index);
              } else {
                _showPopUpMenu(context, items[index].empid, index,
                    items[index].empName!, items[index].empPhone!);
              }
            });
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
              child: Container(
                decoration: controller.isSelected(index)
                    ? new BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 204, 204, 204))
                    : new BoxDecoration(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 225,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(children: [
                                    Text(
                                      items[index].empName!,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 21, 21, 21),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ])),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            workingYear >= 5 && isActive == 1
                                ? IconButton(
                                    icon: Icon(
                                      Icons.flag,
                                      color: Color.fromARGB(255, 64, 215, 53),
                                    ),
                                    onPressed: () {})
                                : IconButton(
                                    icon: Icon(
                                      Icons.flag,
                                      color: Color.fromARGB(255, 47, 42, 86),
                                    ),
                                    onPressed: () {})
                            /*IconButton(
                                icon:
                                    Icon(Icons.edit_rounded, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateQuestion(id: items[index].id!)),
                                  );
                                } /*_navigateToQuestion(context, items[index])*/,
                              ),*/
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Working From: " + workingYear.toString() + " Yrs",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 243, 50, 47),
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  void onPressedNegativeButton() {
    // TODO: implement onPressedNegativeButton
  }

  @override
  void onPressedPositiveButton(String text) {
    // TODO: implement onPressedPositiveButton
  }

  void delete(BuildContext context) {}

  void onSearchChanged(String value) {
    searchResults.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }
    items.forEach((item) {
      if (item.empName!.contains(value) || item.empPhone!.contains(value)) {
        searchResults.add(item);
      }
    });
    setState(() {});
  }

  _deleteFormDialog(BuildContext context, id, int index) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: Text(
              "Delete Dialog",
              style: TextStyle(color: AppColors.loginButtonColor),
            ),
            content: Text(
              "Are you sure you want to delete?",
              // ignore: prefer_const_constructors
              style: TextStyle(color: Colors.teal, fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    employeeService
                        .delete(id)
                        .whenComplete(() => {
                              setState(() {
                                Navigator.pop(context);
                                items.removeAt(index);
                                WidgetHelper.showToast(
                                    'Question Deleted successfully');
                              })
                            })
                        .catchError((error) {
                      WidgetHelper.showToast("Something went wrong");
                    });
                  },
                  child: const Text('Delete')),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }

  void _showPopUpMenu(BuildContext context, id, int index, param3, param4) {}

  void _storePosition(TapDownDetails details) {}

  void refesh() {
    setState(() {
      fetchList();
    });
  }
}
