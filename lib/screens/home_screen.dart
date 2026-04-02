// ignore_for_file: prefer_const_constructors_in_immutables, strict_top_level_inference

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_hours/components/menu.dart';
import 'package:manage_hours/helpers/hour_helpers.dart';
import 'package:manage_hours/models/hour.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hour> listHours = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(title: Text('Manage Hours')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: Icon(Icons.add),
      ),
      body: (listHours.isEmpty)
          ? Center(
              child: Text(
                'Nenhuma hora registrada',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: EdgeInsets.only(left: 4, right: 4),
              children: List.generate(listHours.length, (index) {
                Hour model = listHours[index];
                return Dismissible(
                  key: ValueKey<Hour>(model),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 12),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    remove(model);
                  },
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            showFormModal(model: model);
                          },
                          leading: Icon(Icons.list_alt_rounded, size: 56),
                          title: Text(
                            'Data: ${model.date} hora: ${HourHelpers.minutesToHours(model.minutes)}',
                          ),
                          subtitle: Text(model.description!),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }

  showFormModal({Hour? model}) {
    String title = "Adicionar";
    String confirmButton = "Salvar";
    String cancelButton = "Cancelar";

    TextEditingController dateController = TextEditingController();
    final dataMaskFormatter = MaskTextInputFormatter(mask: '##/##/####');

    TextEditingController minutesController = TextEditingController();
    final minutesMaskFormatter = MaskTextInputFormatter(mask: '##:##');

    TextEditingController descriptionController = TextEditingController();

    if(model != null){
      title = "Editando";
      dateController.text = model.date;
      minutesController.text = HourHelpers.minutesToHours(model.minutes);
      if(model.description != null){
        descriptionController.text = model.description!;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(32),
          child: ListView(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextFormField(
                controller: dateController,
                inputFormatters: [dataMaskFormatter],
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: '01/01/2024',
                  labelText: 'Data',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: minutesController,
                inputFormatters: [minutesMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '00:00',
                  labelText: 'Horas trabalhadas',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'O que foi feito?',
                  labelText: 'Descrição',
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(cancelButton),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Hour hour = Hour(
                        id: Uuid().v1(),
                        date: dateController.text,
                        minutes: HourHelpers.hoursToMinutes(minutesController.text),
                        description: descriptionController.text,
                      );

                      if(descriptionController.text != ''){
                        hour.description = descriptionController.text;
                      }
                      if(model != null){
                        hour.id = model.id;
                      }

                      db
                        .collection(widget.user.uid)
                        .doc(hour.id)
                        .set(hour.toMap());

                      refresh();

                      Navigator.pop(context);
                    }, 
                    child: Text(confirmButton),
                  )
                ],
              ),
              SizedBox(height: 180),
            ],
          ),
        );
      }
    );
  }

  void remove(Hour hour) {
    db.collection(widget.user.uid).doc(hour.id).delete();
    
    refresh();
  }

  void refresh() async {
    // double total = 0;
    List<Hour> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection(widget.user.uid).get();
    for (var doc in snapshot.docs) {
      temp.add(Hour.fromMap(doc.data()));
      // total += hour.minutes;
    }

    setState(() {
      listHours = temp;
    });
  }
}


