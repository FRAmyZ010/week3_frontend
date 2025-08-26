import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonDecode

void main() async {
  // ----------- print login prompt

  print("===== LOGIN =====");
  stdout.write('Username: ');
  String? username = stdin.readLineSync();
  stdout.write('Password: ');
  String? password = stdin.readLineSync();

  final loginBody = {"username": username, "password": password};

  // ------------ send Login request

  final url = Uri.parse('http://localhost:3000/login');
  final response = await http.post(url, body: loginBody);

  if (response.statusCode == 200) {
    final loginData = jsonDecode(response.body);
    int? userID = loginData['user_id'];

    // ------------- LOOP EXPENSE TRACKING MENU

    bool run = true;

    while (run) {
      print('========== Expense Tracking App ==========');
      print('Welcome $username');
      print('1. All Expenses');
      print("2. Today's Expenses");
      print("3. Search Expenses");
      print('4. Add Expense');
      print('5. Delete Expense');
      print('6. Exit');
      stdout.write('Choose... ');
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':

          // ========== All expenses feature
          try {
            final u = Uri.parse('http://localhost:3000/expenses/$userID');
            final r = await http.get(u);
            if (r.statusCode == 200) {
              final data = jsonDecode(r.body);
              if (data is List) {
                if (data.isEmpty) {
                  print('(no expenses)');
                } else {
                  for (final e in data) {
                    final m = (e as Map<String, dynamic>);
                    final id = (m['id'] ?? '').toString();
                    final item = (m['item'] ?? '').toString();
                    final paid = (m['paid'] ?? '').toString();
                    final date = (m['date'] ?? '').toString();
                    print('[#${id}] $item  paid=$paid  date=$date');
                  }
                }
              } else {
                print(data);
              }
            } else {
              print('Failed: ${r.statusCode} ${r.body}');
            }
          } catch (e) {
            print('Error: $e');
          }

          break;

        case '2':

          // ========== Today's expenses feature
          try {
            final u = Uri.parse('http://localhost:3000/expenses/today/$userID');
            final r = await http.get(u);
            if (r.statusCode == 200) {
              final data = jsonDecode(r.body);
              if (data is List) {
                if (data.isEmpty) {
                  print('(no expenses today)');
                } else {
                  for (final e in data) {
                    final m = (e as Map<String, dynamic>);
                    final id = (m['id'] ?? '').toString();
                    final item = (m['item'] ?? '').toString();
                    final paid = (m['paid'] ?? '').toString();
                    final date = (m['date'] ?? '').toString();
                    print('[#${id}] $item  paid=$paid  date=$date');
                  }
                }
              } else {
                print(data);
              }
            } else {
              print('Failed: ${r.statusCode} ${r.body}');
            }
          } catch (e) {
            print('Error: $e');
          }

          break;

        case '3':

          // ========== Search expenses feature

          stdout.write('Item to search: ');
          String? searchItem = stdin.readLineSync();

          if (searchItem != null && searchItem.isNotEmpty) {
            // Write your code here
          }

          break;

        case '4':

          // ========== Add expense feature

          print('===== Add new item =====');
          stdout.write('Item: ');
          String? item = stdin.readLineSync();
          stdout.write('Paid: ');
          String? paid = stdin.readLineSync();

          // Write your code here

          break;

        case '5':

          // ========== Delete expense feature

          print('===== Delete item =====');
          stdout.write('Item ID: ');
          int? itemID = int.tryParse(stdin.readLineSync() ?? '');

          // Write your code here

          break;

        case '6':
          run = false;
          print('---------- Bye ----------');
          break;
      }
    }
  } else if (response.statusCode == 401 || response.statusCode == 500) {
    final result = response.body;
    print(result);
  } else {
    print('Unknown error!');
  }
}
