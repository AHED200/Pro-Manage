import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PhaseField extends StatefulWidget {
  PhaseField();

  DateFormat format = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String? phaseName;
  late String startDate = format.format(now).toString();
  late String dueDate = format.format(now.add(Duration(days: 1))).toString();

  @override
  State<PhaseField> createState() => _PhaseFieldState();
}

class _PhaseFieldState extends State<PhaseField> {
  TextEditingController phaseNameController = TextEditingController();
  DateRangePickerController dateController = DateRangePickerController();
  final toastKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 55,
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: TextField(
                controller: phaseNameController,
                textInputAction: TextInputAction.go,
                decoration: InputDecoration(label: Text('Phase name')),
                onChanged: (xx){
                  this.widget.phaseName = phaseNameController.text;
                },
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            TextButton(
              child: Text(
                'Start: ' + widget.startDate + '\n' + 'End: ' + widget.dueDate,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        content: SizedBox(
                          height: 250,
                          width: 250,
                          child: SfDateRangePicker(
                            enablePastDates: false,
                            controller: dateController,
                            confirmText: 'Ok',
                            showActionButtons: true,
                            selectionMode:
                                DateRangePickerSelectionMode.extendableRange,
                            onCancel: () {
                              Navigator.pop(context);
                            },
                            onSubmit: (date) {
                              if (dateController.selectedRange!.endDate !=
                                      null &&
                                  dateController.selectedRange!.startDate !=
                                      null) {
                                setState(() {
                                  widget.dueDate = widget.format.format(
                                      DateTime.parse(dateController
                                          .selectedRange!.endDate
                                          .toString()));
                                  widget.startDate = widget.format.format(
                                      DateTime.parse(dateController
                                          .selectedRange!.startDate
                                          .toString()));
                                });
                                Navigator.pop(context);
                              } else {
                                showFlash(
                                    context: context,
                                    duration: Duration(seconds: 4),
                                    builder: (context, controller) {
                                      return Flash.bar(
                                          controller: controller,
                                          backgroundColor: Color(0xBB393939),
                                          borderRadius: BorderRadius.circular(10),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 40),
                                          forwardAnimationCurve:
                                              Curves.easeOutBack,
                                          child: FlashBar(
                                              content: Text(
                                                  'You must choice start date and end date.')));
                                    });
                              }
                            },
                          ),
                        ),
                      );
                    });
              },
            )
          ],
        )
      ],
    );
  }
}
