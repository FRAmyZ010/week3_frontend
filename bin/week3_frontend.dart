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

              // helper for padding + time format: YYYY-MM-DD HH:MM:SS.mmm
              String two(int n) => n.toString().padLeft(2, '0');
              String fmt(DateTime dt) =>
                  "${dt.year}-${two(dt.month)}-${two(dt.day)} "
                  "${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}."
                  "${dt.millisecond.toString().padLeft(3, '0')}";

              if (data is List) {
                print("------------- All expenses ----------");
                if (data.isEmpty) {
                  print("Total expenses = 0฿");
                } else {
                  int total = 0;
                  for (final e in data) {
                    final m = (e as Map<String, dynamic>);
                    final id = m['id'] ?? '';
                    final item = m['item'] ?? '';
                    final paid = (m['paid'] as num?)?.toInt() ?? 0;
                    final dt = DateTime.parse(m['date'].toString()).toLocal();
                    print("$id. $item : ${paid}฿ : ${fmt(dt)}");
                    total += paid;
                  }
                  print("Total expenses = ${total}฿");
                }
              } else {
                // unexpected structure
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

              // helper for padding + time format: YYYY-MM-DD HH:MM:SS.mmm
              String two(int n) => n.toString().padLeft(2, '0');
              String fmt(DateTime dt) =>
                  "${dt.year}-${two(dt.month)}-${two(dt.day)} "
                  "${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}."
                  "${dt.millisecond.toString().padLeft(3, '0')}";

              if (data is List) {
                print("------------- Today's expenses ----------");
                if (data.isEmpty) {
                  print("Total expenses = 0฿");
                } else {
                  int total = 0;
                  for (final e in data) {
                    final m = (e as Map<String, dynamic>);
                    final id = m['id'] ?? '';
                    final item = m['item'] ?? '';
                    final paid = (m['paid'] as num?)?.toInt() ?? 0;
                    final dt = DateTime.parse(m['date'].toString()).toLocal();
                    print("$id. $item : ${paid}฿ : ${fmt(dt)}");
                    total += paid;
                  }
                  print("Total expenses = ${total}฿");
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
