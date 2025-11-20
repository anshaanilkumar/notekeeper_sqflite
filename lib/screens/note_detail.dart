import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle; // 🔹 make it final
  const NoteDetail({super.key, required this.appBarTitle});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  static const _priorities = ['High', 'Low'];
  String _currentPriority = 'High';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //user press back navigation button in device
      onWillPop: () {
        moveToLastScreen();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
          leading: IconButton(onPressed: (){
            moveToLastScreen();
          }, icon: Icon(Icons.arrow_back)),// 🔹 use widget.appBarTitle
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
          child: ListView(
            children: [
              // 🔹 Dropdown
              ListTile(
                title: DropdownButton<String>(
                  value: _currentPriority,
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      _currentPriority = valueSelectedByUser!;
                      debugPrint('User selected $_currentPriority');
                    });
                  },
                ),
              ),

              // 🔹 Title TextField
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    debugPrint('Something changed in Title TextField');
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              // 🔹 Description TextField
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: TextField(
                  controller: descriptionController,
                  onChanged: (value) {
                    debugPrint('Something changed in Description TextField');
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),

              // 🔹 Buttons 
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('Save button clicked');
                        },
                        child: const Text(
                          "Save",
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 🔹 go back
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text(
                          "Cancel",
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void moveToLastScreen(){
    Navigator.pop(context);
  }
}
