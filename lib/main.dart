import 'dart:math';

import 'package:flutter/material.dart';

// Flutter DataGrid package import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(
      MaterialApp(title: 'Syncfusion Flutter DataGrid', home: LoadMoreDemo()));
}

class LoadMoreDemo extends StatefulWidget {
  LoadMoreDemo({Key key}) : super(key: key);

  @override
  _LoadMoreDemoState createState() => _LoadMoreDemoState();
}

class _LoadMoreDemoState extends State<LoadMoreDemo> {
  List<Employee> _employees = <Employee>[];
  EmployeeDataSource _employeeDataSource;

  @override
  void initState() {
    _addMoreRows(_employees, 20);
    _employeeDataSource = EmployeeDataSource(employeeData: _employees);
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
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('LOAD MORE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (context is StatefulElement &&
                          context.state != null &&
                          context.state.mounted) {
                        setState(() {
                          showIndicator = true;
                        });
                      }
                      await loadMoreRows();
                      if (context is StatefulElement &&
                          context.state != null &&
                          context.state.mounted) {
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
          GridNumericColumn(mappingName: 'id', headerText: 'ID'),
          GridTextColumn(mappingName: 'name', headerText: 'Name'),
          GridTextColumn(
            mappingName: 'designation',
            headerText: 'Designation',
            columnWidthMode: ColumnWidthMode.cells,
          ),
          GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
        ],
      ),
    );
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

void _addMoreRows(List<Employee> employeeData, int count) {
  final Random _random = Random();
  int startIndex = employeeData.isNotEmpty ? employeeData.length : 0,
      endIndex = startIndex + count;
  for (int i = startIndex; i < endIndex; i++) {
    employeeData.add(Employee(
      1000 + i,
      _names[_random.nextInt(_names.length - 1)],
      _designation[_random.nextInt(_designation.length - 1)],
      10000 + _random.nextInt(10000),
    ));
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource<Employee> {
  EmployeeDataSource({List<Employee> employeeData}) {
    _employeeData = employeeData;
  }
  List<Employee> _employeeData;

  @override
  List<Employee> get dataSource => _employeeData;

  @override
  Object getValue(Employee employee, String columnName) {
    switch (columnName) {
      case 'id':
        return employee.id;
        break;
      case 'name':
        return employee.name;
        break;
      case 'salary':
        return employee.salary;
        break;
      case 'designation':
        return employee.designation;
        break;
      default:
        return ' ';
        break;
    }
  }

  @override
  Future<void> handleLoadMoreRows() async {
    await Future.delayed(Duration(seconds: 5));
    _addMoreRows(_employeeData, 10);
    notifyListeners();
  }
}
