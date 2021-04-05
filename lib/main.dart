import 'dart:math';

import 'package:flutter/material.dart';

// Flutter DataGrid package import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(
      MaterialApp(title: 'Syncfusion Flutter DataGrid', home: LoadMoreDemo()));
}

class LoadMoreDemo extends StatefulWidget {
  LoadMoreDemo({Key? key}) : super(key: key);

  @override
  _LoadMoreDemoState createState() => _LoadMoreDemoState();
}

class _LoadMoreDemoState extends State<LoadMoreDemo> {
  List<Employee> _employees = <Employee>[];
  late EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    _populateEmployeeData(20);
    _employeeDataSource = EmployeeDataSource(employees: _employees);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: _employeeDataSource,
        loadMoreViewBuilder: (BuildContext context, LoadMoreRows loadMoreRows) {
          bool showIndicator = false;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            if (showIndicator) {
              return Container(
                  height: 60.0,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: BorderDirectional(
                          top: BorderSide(
                              width: 1.0,
                              color: Color.fromRGBO(0, 0, 0, 0.26)))),
                  child: CircularProgressIndicator());
            } else {
              return Container(
                height: 60.0,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: BorderDirectional(
                        top: BorderSide(
                            width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.26)))),
                child: Container(
                  height: 36.0,
                  width: 142.0,
                  child: MaterialButton(
                    color: Colors.blue,
                    child: Text('LOAD MORE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (context is StatefulElement && context.state.mounted) {
                        setState(() {
                          showIndicator = true;
                        });
                      }
                      await loadMoreRows();
                      if (context is StatefulElement && context.state.mounted) {
                        setState(() {
                          showIndicator = false;
                        });
                      }
                    },
                  ),
                ),
              );
            }
          });
        },
        columns: <GridColumn>[
          GridTextColumn(
              columnName: 'id',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'ID',
                  ))),
          GridTextColumn(
              columnName: 'name',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Name'))),
          GridTextColumn(
              width: 120.0,
              columnName: 'designation',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Designation',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridTextColumn(
              columnName: 'salary',
              label: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text('Salary'))),
        ],
      ),
    );
  }

  void _populateEmployeeData(int count) {
    final Random _random = Random();
    int startIndex = _employees.isNotEmpty ? _employees.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employees.add(Employee(
        1000 + i,
        _names[_random.nextInt(_names.length - 1)],
        _designation[_random.nextInt(_designation.length - 1)],
        10000 + _random.nextInt(10000),
      ));
    }
  }
}

final List<String> _names = <String>[
  'Welli',
  'Blonp',
  'Folko',
  'Furip',
  'Folig',
  'Picco',
  'Frans',
  'Warth',
  'Linod',
  'Simop',
  'Merep',
  'Riscu',
  'Seves',
  'Vaffe',
  'Alfki'
];

final List<String> _designation = <String>[
  'Project Lead',
  'Developer',
  'Manager',
  'Designer',
  'System Analyst',
  'CEO'
];

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employees}) {
    _employeeData = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  void _addMoreRows(int count) {
    final Random _random = Random();
    int startIndex = _employeeData.isNotEmpty ? _employeeData.length : 0,
        endIndex = startIndex + count;
    for (int i = startIndex; i < endIndex; i++) {
      _employeeData.add(DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: 1000 + i),
        DataGridCell<String>(
            columnName: 'name',
            value: _names[_random.nextInt(_names.length - 1)]),
        DataGridCell<String>(
            columnName: 'designation',
            value: _designation[_random.nextInt(_designation.length - 1)]),
        DataGridCell<int>(
            columnName: 'salary', value: 10000 + _random.nextInt(10000)),
      ]));
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 5));
    _addMoreRows(10);
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
