import 'package:flutter/material.dart';
import 'package:todon/screens/todo_screens.dart';

import '../screens/expensetracker.dart';
class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
              accountName: Text('OPTIONS'),
              accountEmail: Text('Contact Address : chandanmoolya2004@gmail.com'),
            decoration: BoxDecoration(color: Colors.pink),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const TodoList())),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Expense Tracker'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ExpenseTrackerScreen())),
          ),
        ],
      ),
    );
  }
}




