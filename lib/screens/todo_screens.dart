import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todon/helpers/drawer.dart';
import '../models/fortodo.dart';
class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<TodoItem> _todos = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int? _editIndex;


  void _addTodo() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty && _selectedDate != null) {
      setState(() {
        _todos.add(TodoItem(title, description, _selectedDate));
        _titleController.text = '';
        _descriptionController.text = '';
        _dateController.clear();
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _editTodo(int index) {
    final todo = _todos[index];
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _selectedDate = todo.date;
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _editIndex = index;
  }


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Todo List'),
        ),
        drawer: const DrawerNavigation(),
        body: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: const InputDecoration(
                          hintText: 'Date',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.redAccent,),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text('Add'),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_todos[index].title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_todos[index].description),
                              Text(
                                'Date: ${DateFormat('yyyy-MM-dd').format(_todos[index].date)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  _editTodo(index); // Edit the specific todo item
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _removeTodo(index);
                                },
                              ),
                            ],
                          ),
                        );
                        },
                      ),
                ),
              ],
            ),
            ),
        );
    }
}