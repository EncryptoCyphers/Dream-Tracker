import 'package:dream_tracker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../colors.dart';

class PreferenceDetails extends StatefulWidget {
  final int id;
  final String preference;
  const PreferenceDetails(
      {super.key, required this.preference, required this.id});

  @override
  State<PreferenceDetails> createState() => _PreferenceDetailsState();
}

class _PreferenceDetailsState extends State<PreferenceDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _goalAmtController = TextEditingController();
  NumberFormat _formatter = NumberFormat.decimalPattern('en-IN');

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _goalAmtController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = (widget.id < 7) ? widget.preference : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.horizontal_rule),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter Preference Details",
                style: TextStyle(
                    fontSize: 20,
                    color: myPrimarySwatch,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        enabled: (widget.id < 7) ? false : true,
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter preference name",
                          prefix: Icon(Icons.notes),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid preference';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter preference description",
                          prefix: Icon(Icons.book),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            final int? parsed = int.tryParse(newValue.text);
                            // try {
                            final String formatted = _formatter.format(parsed);
                            return TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                  offset: formatted.length),
                            );
                            // } catch (e) {
                            //   return const TextEditingValue();
                            // }
                          }),
                        ],
                        controller: _goalAmtController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter goal amount",
                          prefix: Icon(Icons.currency_rupee),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value) == 0) {
                            return 'Please enter valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myPrimarySwatch,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                fixedSize: const Size(100, 50)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myPrimarySwatch,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                                fixedSize: const Size(100, 50)),
                            onPressed: () {
                              _goalAmtController.text =
                                  _goalAmtController.text.replaceAll(",", "");
                              if (_formKey.currentState!.validate()) {
                                addGoals(
                                    _nameController.text,
                                    _descriptionController.text,
                                    int.parse(_goalAmtController.text),
                                    widget.id);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Submit"),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
