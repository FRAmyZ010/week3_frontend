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

          // Write your code here

          break;

        case '2':

          // ========== Today's expenses feature

          // Write your code here

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
         if (item == null || item.trim().isEmpty || paid == null || paid.trim().isEmpty) {
    print('Item and Paid cannot be empty.');
    break;
  }

  final paidNum = num.tryParse(paid);
  if (paidNum == null) {
    print('Paid must be a number.');
    break;
  }

  try {
    final addUrl = Uri.parse('http://localhost:3000/add-expenses');
    final addBody = {
      'item': item.trim(),
      'paid': paidNum.toString(),
      'user_id': userID.toString(), 
    };

    final addRes = await http.post(addUrl, body: addBody);

    if (addRes.statusCode == 201) {
      final data = jsonDecode(addRes.body);
      print('${data['message']} (id: ${data['expense_id']})');
    } else {
      print('Failed to add expense [${addRes.statusCode}] -> ${addRes.body}');
    }
  } catch (e) {
    print('Connection error: $e');
  }

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
