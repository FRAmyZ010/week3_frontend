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

          final expenseurl = Uri.parse('http://localhost:3000/expenses/$userID',);
          final response = await http.get(expenseurl);

          if(response.statusCode == 200){
            final result = jsonDecode(response.body) as List;
            int total = 0;

            print("----------- All Expenses -----------");
            for (Map exp in result){
              
              total += exp['paid'] as int;
              print( 
                "${exp['id']}. ${exp['item']} : ${exp['paid']}฿ : ${exp['date']}"
              );
            }
            print("Total expenses = $total ฿");
          }else{
            print('Error ${response.statusCode}: ${response.body}');
          }

          break;

        case '2':

          // ========== Today's expenses feature

          // Write your code here

          final todayurl = Uri.parse( 
            'http://localhost:3000/expenses/today/$userID',
          );
          final todayResponse = await http.get(todayurl);

          if (todayResponse.statusCode == 200){
            final result = jsonDecode(todayResponse.body) as List;
            int total = 0;

            print("-------------- Today's Expenses --------------");

            for (Map exp in result){
              total += exp['paid'] as int;
              print(
                "${exp['id']}. ${exp['item']} : ${exp['paid']}฿ : ${exp['date']}"
              );
            }
            print("Total expenses = $total฿");
          }else{
            print('Error ${todayResponse.statusCode}: ${todayResponse.body}');
          }

          break;

        // ========== Search expenses feature
        case '3':
          // ===== Search Expenses =====
          stdout.write('Item to search: ');
          String? searchItem = stdin.readLineSync();

          if (searchItem != null && searchItem.isNotEmpty) {
            final searchUrl = Uri.parse(
              'http://localhost:3000/expense/search/$userID?keyword=${Uri.encodeComponent(searchItem)}',
            );

            final searchResponse = await http.get(searchUrl);

            if (searchResponse.statusCode == 200) {
              List results = jsonDecode(searchResponse.body);

              if (results.isEmpty) {
                print('No results found.');
              } else {
                print('===== Search Results =====');
                int price = 0;

                for (var e in results) {
                  price = price + e['paid'] as int;
                  print(
                    " ${e['id']}.  ${e['item']}: ${e['paid']}฿ : ${e['date']}",
                  );
                }
                print("Total expenses = $price฿");
              }
            } else {
              print('Search failed: ${searchResponse.statusCode}');
            }
          } else {
            print('Search keyword is empty.');
          }
          break;

case '4':
  // ========== Add expense feature
  print('===== Add New Expense =====');
  stdout.write('Item: ');
  String? item = stdin.readLineSync();
  stdout.write('Paid: ');
  String? paid = stdin.readLineSync();

  if (item == null || item.trim().isEmpty || paid == null || paid.trim().isEmpty) {
    print('Item and Paid cannot be empty.');
    break;
  }

  final paidNum = int.tryParse(paid);
  if (paidNum == null) {
    print('Paid must be a number.');
    break;
  }


  try {
    final addUrl = Uri.parse('http://localhost:3000/add-expenses');
    final addBody = jsonEncode({
      'item': item.trim(),
      'paid': paidNum,     
      'user_id': userID,   
    });

    final addRes = await http.post(
      addUrl,
      headers: {"Content-Type": "application/json"},
      body: addBody,
    );

    if (addRes.statusCode == 201) {
      final data = jsonDecode(addRes.body);
      print('${data['message']}');
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
          if (itemID == null) {
            print('Please enter a valid ID.');
            break;
          }

          try {
            final delUrl = Uri.parse(
              'http://localhost:3000/del-expenses/$itemID',
            );
            final delRes = await http.delete(delUrl);

            if (delRes.statusCode == 200) {
              final data = jsonDecode(delRes.body);
              print(data['message']);
            } else if (delRes.statusCode == 404) {
              print('Expense not found.');
            } else {
              print(
                'Failed to delete expense [${delRes.statusCode}] -> ${delRes.body}',
              );
            }
          } catch (e) {
            print('Connection error: $e');
          }
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
