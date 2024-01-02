import 'package:flutter/material.dart';
import 'package:i_have_todo/app/constants/them_data.dart';
import 'package:intl/intl.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class DateSelect extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final Duration duration;
  const DateSelect({
    Key? key,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.duration = const Duration(days: 365),
  }) : super(key: key);

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  late List<DateTime> items;

  @override
  void initState() {
    super.initState();
    items = _getDates();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 60,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5, bottom: 5),
            child: NeoPopButton(
              color: kWhiteColor,
              bottomShadowColor:
                  widget.initialDate != null ? kSecondaryColor : kGreenColor,
              rightShadowColor:
                  widget.initialDate != null ? kSecondaryColor : kGreenColor,
              buttonPosition: Position.fullBottom,
              onTapUp: () {
                widget.onDateSelected(null);
              },
              border: Border.all(
                color:
                    widget.initialDate != null ? kSecondaryColor : kGreenColor,
                width: 1,
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'All',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 5, bottom: 5),
                  child: NeoPopButton(
                    color: kWhiteColor,
                    bottomShadowColor:
                        !isSameDay(widget.initialDate, items[index])
                            ? kSecondaryColor
                            : kGreenColor,
                    rightShadowColor:
                        !isSameDay(widget.initialDate, items[index])
                            ? kSecondaryColor
                            : kGreenColor,
                    buttonPosition: Position.fullBottom,
                    onTapUp: () {
                      widget.onDateSelected(items[index]);
                    },
                    border: Border.all(
                      color: !isSameDay(widget.initialDate, items[index])
                          ? kSecondaryColor
                          : kGreenColor,
                      width: 1,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getFormattedDate(items[index], 'dd'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            getFormattedDate(items[index], 'MMM'),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) {
      return false;
    }
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getFormattedDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  List<DateTime> _getDates() {
    final endDate = (widget.initialDate ?? DateTime.now())
        .add(widget.duration)
        .subtract(const Duration(days: 1));
    List<DateTime> days = [];
    for (int i = 0;
        i <= endDate.difference(widget.firstDate ?? DateTime.now()).inDays;
        i++) {
      days.add((widget.firstDate ?? DateTime.now()).add(Duration(days: i)));
    }
    return days;
  }
}
