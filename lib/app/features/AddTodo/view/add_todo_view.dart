import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:i_have_todo/app/constants/decorations.dart';
import 'package:i_have_todo/app/constants/them_data.dart';
import 'package:i_have_todo/app/features/AddTodo/bloc/add_todo_bloc.dart';
import 'package:i_have_todo/app/features/Home/bloc/todo_home_bloc.dart';
import 'package:intl/intl.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final _block = AddTodoBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  DateTime? _dueDate;
  bool _isReminder = false;
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTodoBloc, AddTodoState>(
      bloc: _block,
      listener: (context, state) {
        if (state is AddTodoSuccess) {
          BlocProvider.of<TodoHomeBloc>(context).add(TodoHomeEvent());
          Navigator.pop(context);
        }
      },
      buildWhen: (previous, current) => current is AddTodoLoading,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Add Todo',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                      ),
                      height: 30,
                      width: 30,
                      child: NeoPopButton(
                        color: kWhiteColor,
                        onTapUp: () {
                          HapticFeedback.vibrate();
                          Navigator.pop(context);
                        },
                        onTapDown: () {
                          HapticFeedback.vibrate();
                        },
                        parentColor: Colors.transparent,
                        buttonPosition: Position.center,
                        child: const Icon(
                          Icons.close,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title'.toUpperCase(),
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      decoration: kInputDecoration(
                        hintText: 'Enter title',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description'.toUpperCase(),
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description cannot be empty';
                        }
                        return null;
                      },
                      decoration: kInputDecoration(
                        hintText: 'Description ...',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                // add due date

                // attach file
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColor),
                          ),
                          height: 30,
                          width: 30,
                          child: NeoPopButton(
                            color: kWhiteColor,
                            onTapUp: () async {
                              HapticFeedback.vibrate();
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(allowMultiple: true);
                              if (result != null) {
                                List<File> files = result.paths
                                    .map((path) => File(path!))
                                    .toList();
                                setState(() {
                                  this.files = files;
                                });
                              }
                            },
                            onTapDown: () {
                              // HapticFeedback.vibrate();
                            },
                            parentColor: Colors.transparent,
                            buttonPosition: Position.center,
                            child: const Icon(
                              Icons.attach_file,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attach File'.toUpperCase(),
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                )),
                            Text(
                                files.length > 0
                                    ? '${files.length} files attached'
                                    : 'Select files to attach (optional)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 10,
                                      color: kGreyColor,
                                    )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Due Date'.toUpperCase(),
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                    TextFormField(
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Due date cannot be empty';
                        }
                        return null;
                      },
                      onTap: () {
                        HapticFeedback.vibrate();
                        // show date and time picker
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 30)),
                        ).then((value) async {
                          if (value != null) {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              if (value.day == DateTime.now().day &&
                                  time.hour < DateTime.now().hour) {
                                return;
                              }
                              setState(() {
                                _dueDate = DateTime(
                                  value.year,
                                  value.month,
                                  value.day,
                                  time.hour,
                                  time.minute,
                                );
                                _dueDateController.text =
                                    DateFormat('dd-MMM-yyyy HH:mm a')
                                        .format(_dueDate!);
                              });
                            }
                          }
                        });
                      },
                      controller: _dueDateController,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: kInputDecoration(
                        hintText: 'Ex: 12/12/2021 (optional)',
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Checkbox(
                      value: _isReminder,
                      onChanged: (value) {
                        setState(() {
                          _isReminder = value!;
                        });
                      },
                    ),
                    const Text('Set Reminder',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                  ],
                ),
                const SizedBox(height: 10),

                if (state is AddTodoLoading) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: NeoPopButton(
                      color: kPrimaryColor,
                      bottomShadowColor: kGreyColor,
                      rightShadowColor: kGreyColor,
                      onTapUp: () {},
                      onTapDown: () {},
                      buttonPosition: Position.fullBottom,
                      depth: 4,
                      parentColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SpinKitWave(
                            color: kWhiteColor,
                            type: SpinKitWaveType.start,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                // hide button when state is AddTodoLoading
                if (state is! AddTodoLoading) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: NeoPopButton(
                      color: kPrimaryColor,
                      bottomShadowColor: kGreyColor,
                      rightShadowColor: kGreyColor,
                      onTapUp: () {
                        HapticFeedback.vibrate();
                        if (_formKey.currentState!.validate()) {
                          _block.add(
                            AddTodoEvent(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              dueDate: _dueDate ?? DateTime.now(),
                              isReminder: _isReminder,
                              files: files,
                            ),
                          );
                        }
                      },
                      onTapDown: () {
                        // HapticFeedback.vibrate();
                      },
                      buttonPosition: Position.fullBottom,
                      depth: 4,
                      parentColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Save',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
