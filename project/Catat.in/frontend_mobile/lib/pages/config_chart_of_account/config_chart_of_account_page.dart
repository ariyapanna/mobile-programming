import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_mobile/components/common/app_bar.dart';
import 'package:frontend_mobile/exceptions/api_exception.dart';
import 'package:frontend_mobile/models/chart_of_account.dart';
import 'package:frontend_mobile/utils/api_client.dart';
import 'package:frontend_mobile/utils/notification.dart';

class ConfigChartOfAccountPage extends StatefulWidget {
    const ConfigChartOfAccountPage({super.key});

    @override
    State<ConfigChartOfAccountPage> createState() => _ConfigChartOfAccountPageState();
}

class _ConfigChartOfAccountPageState extends State<ConfigChartOfAccountPage> {
    final apiClient = ApiClient(baseUrl: dotenv.env['CATAT_IN_API_BASE_URL']!);
    bool isLoading = true; // flag untuk loading

    List<Account> accounts = [];

    final _formKey = GlobalKey<FormState>();

    // Input controllers
    TextEditingController codeController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    @override
    void initState() {
        super.initState();
        fetchAccounts();
    }

    Future<void> fetchAccounts() async {
        setState(() {
            isLoading = true;
        });

        try
        {
            final response = await apiClient.get('/accounts');
            final data = response['data'] as List;
            
            if(data.isEmpty) 
            {
                setState(() {
                    isLoading = false;
                });
                return;
            }

            accounts = (data).map((json) => Account.fromJson(json)).toList();
        }
        catch(e)
        {
            print(e);
        }
        finally
        {
            setState(() {
                isLoading = false;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Config Chart of Account'),
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // tampil loading
            : accounts.isEmpty ?
                Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(Icons.account_balance, size: 80, color: Colors.grey),
                        SizedBox(height: 20),
                        Text('No accounts found'),
                    ],
                ))
                : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: DataTable(
                        columns: const [
                            DataColumn(label: Text('Code')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Type')),
                            DataColumn(label: Text('Normal Balance')),
                        ],
                        rows: accounts.map((account) => DataRow(cells: [
                            DataCell(Text(account.code)),
                            DataCell(Text(account.name)),
                            DataCell(Text(account.type)),
                            DataCell(Text(account.normalBalance)),
                        ])).toList(),
                    ),
                )
            ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
            showDialog(
            context: context,
            builder: (context) {
                String? selectedType; 
                String? selectedNormalBalance;
                String? errorMessage;
                return AlertDialog(
                    title: Text('Add New Account'),
                    content: StatefulBuilder(
                        builder: (context, setState) => Form(
                            key: _formKey,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    TextFormField(
                                        controller: codeController,
                                        decoration: InputDecoration(labelText: 'Code'),
                                        validator: (value) {
                                            if(value == null || value.isEmpty)
                                                return 'Please enter a code';

                                            return null;
                                        }
                                    ),
                                    TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(labelText: 'Name'),
                                        validator: (value) {
                                            if(value == null || value.isEmpty)
                                                return 'Please enter a name';

                                            return null;
                                        }
                                    ),
                                    SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            labelText: 'Type',
                                            border: UnderlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        ),
                                        value: selectedType,
                                        items: [
                                            'Assets',
                                            'Liabilities',
                                            'Equity',
                                            'Revenue',
                                            'Expenses',
                                        ].map((type) {
                                            return DropdownMenuItem<String>(
                                                value: type,
                                                child: Text(type),
                                            );
                                        }).toList(),
                                        onChanged: (value) {
                                            setState(() {
                                                selectedType = value;
                                            });
                                        },
                                        validator: (value) =>( value == null || value.isEmpty) ? 'Please select a type' : null,
                                    ),
                                    SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                            labelText: 'Normal Balance',
                                            border: UnderlineInputBorder(),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        ),
                                        value: selectedNormalBalance,
                                        items: [
                                            'Debit',
                                            'Credit',
                                        ].map((type) {
                                            return DropdownMenuItem<String>(
                                                value: type,
                                                child: Text(type),
                                            );
                                        }).toList(),
                                        onChanged: (value) {
                                            setState(() {
                                                selectedNormalBalance = value;
                                            });
                                        },
                                        validator: (value) => ( value == null || value.isEmpty) ? 'Please select a normal balance' : null,
                                    ),
                                    if(errorMessage != null) ...[
                                    SizedBox(height: 8),
                                    Text(
                                        errorMessage!,
                                        style: TextStyle(color: Colors.red),
                                    ),
                                    ],
                                ],
                            ),
                        )
                    ),
                    actions: [
                        TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close', style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                        onPressed: () async {
                            if(_formKey.currentState!.validate()) 
                            {
                                try
                                {
                                    await apiClient.post('/accounts', {
                                        'code': codeController.text,
                                        'name': nameController.text,
                                        'type': selectedType,
                                        'normalBalance': selectedNormalBalance,
                                    });
                                    fetchAccounts();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Account added successfully'),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                        ),
                                    );
                                    Navigator.pop(context);
                                }
                                catch(e)
                                {
                                    String errorMessage = 'Something went wrong, please try again later';
                                    if(e is ApiException && e.statusCode != 500)
                                        errorMessage = e.message;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                        ),
                                    );
                                    Navigator.pop(context);
                                }
                            }
                        },
                        child: Text('Save'),
                        ),
                    ],
                    );
                },
            );
        },
        child: Icon(
            Icons.add,
            color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Account',
        ),
    );
    }
}