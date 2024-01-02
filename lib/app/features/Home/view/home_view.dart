import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_have_todo/app/Components/date_select.dart';
import 'package:i_have_todo/app/Components/fileList.dart';
import 'package:i_have_todo/app/constants/them_data.dart';
import 'package:i_have_todo/app/features/AddTodo/view/add_todo_view.dart';
import 'package:i_have_todo/app/features/Home/bloc/todo_home_bloc.dart';
import 'package:i_have_todo/app/utils/date_time_utils.dart';
import 'package:neopop/utils/color_utils.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TodoHomeBloc _todoHomeBloc = TodoHomeBloc();

  @override
  void initState() {
    super.initState();
    _todoHomeBloc.add(TodoHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, isScrolled) {
              return [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  pinned: true,
                  floating: true,
                  snap: true,
                  centerTitle: false,
                  expandedHeight: 180,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        decoration: const BoxDecoration(),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 5),
                            Image.asset(
                              'assets/images/logo.png',
                              width: 80,
                              height: 100,
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Todo',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                  ),
                                  BlocBuilder<TodoHomeBloc, TodoHomeState>(
                                    bloc: _todoHomeBloc,
                                    builder: (context, state) {
                                      if (state is TodoHomeSuccess) {
                                        return Text(
                                          'Task ${state.totalDone}/${state.totalTodo}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: kGreyColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        );
                                      }
                                      return Text(
                                        'updating ...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: kGreyColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  bottom: PreferredSize(
                      preferredSize: const Size(double.infinity, 90),
                      child: BlocBuilder<TodoHomeBloc, TodoHomeState>(
                        bloc: _todoHomeBloc,
                        builder: (context, state) {
                          if (state is TodoHomeSuccess) {
                            return DateSelect(
                              onDateSelected: (DateTime? dt) {
                                _todoHomeBloc.add(
                                  GetTodoEvent(
                                    filterDate: dt,
                                  ),
                                );
                              },
                              firstDate: DateTime.now(),
                              duration: const Duration(days: 30),
                              initialDate: state.filterDate,
                            );
                          }
                          return DateSelect(
                            onDateSelected: (DateTime? dt) {
                              _todoHomeBloc.add(
                                GetTodoEvent(
                                  filterDate: dt,
                                ),
                              );
                            },
                            firstDate: DateTime.now(),
                            duration: const Duration(days: 30),
                          );
                        },
                      )),
                ),
              ];
            },
            body: BlocConsumer<TodoHomeBloc, TodoHomeState>(
              bloc: _todoHomeBloc,
              listener: (context, state) {
                if (state is TodoHomeFailure) {
                  EasyLoading.dismiss();
                }
                if (state is TodoHomeUpdateSuccess) {
                  _todoHomeBloc.add(TodoHomeEvent());
                }
                if (state is TodoHomeUpdateFailure) {
                  EasyLoading.dismiss();
                }
                if (state is TodoHomeLoading) {
                  EasyLoading.show(
                    maskType: EasyLoadingMaskType.custom,
                  );
                }
                if (state is TodoHomeSuccess) {
                  EasyLoading.dismiss();
                }
              },
              builder: (context, state) {
                if (state is TodoHomeSuccess) {
                  return state.todos.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No data!',
                              style: TextStyle(
                                color: kBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Add your todo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.todos.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                state.todos[index]['title'] ?? '',
                                style: TextStyle(
                                  color: kBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration:
                                      state.todos[index]['isDone'] ?? false
                                          ? TextDecoration.lineThrough
                                          : null,
                                ),
                              ),
                              subtitle: Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: kGreyColor,
                                        width: 0.4,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(state.todos[index]['description'] ??
                                          ''),
                                      state.todos[index]['isSetReminder']
                                          ? SizedBox(height: 10)
                                          : const SizedBox(),
                                      Row(
                                        children: [
                                          if (state.todos[index]
                                              ['isSetReminder']) ...[
                                            const Icon(
                                              Icons.alarm,
                                              size: 16,
                                              color: kSecondaryColor,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${getFormattedDate(convertTimestampToDateTime(state.todos[index]['dueDate']), 'dd MMM yyyy hh:mm a')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: kSecondaryColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ]
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  )),
                              trailing: state.todos[index]['attachments'] !=
                                      null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kPrimaryColor),
                                      ),
                                      height: 30,
                                      width: 30,
                                      child: NeoPopButton(
                                        color: kWhiteColor,
                                        onTapUp: () {
                                          HapticFeedback.vibrate();
                                          showModalBottomSheet(
                                            context: context,
                                            useRootNavigator: true,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(0),
                                                  topLeft: Radius.circular(0)),
                                            ),
                                            builder: (context) => Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: NeoPopButton(
                                                  topShadowColor: kGreyColor,
                                                  color: kWhiteColor,
                                                  border: const Border(
                                                    top: BorderSide(
                                                      color: kGreyColor,
                                                      width: 6,
                                                    ),
                                                  ),
                                                  buttonPosition:
                                                      Position.fullBottom,
                                                  depth: 4,
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: BlocProvider.value(
                                                      value: _todoHomeBloc,
                                                      child: FilesViewUrl(
                                                          files: state
                                                              .todos[index][
                                                                  'attachments']
                                                              .map<String>((e) =>
                                                                  e.toString())
                                                              .toList()),
                                                    ),
                                                  ),
                                                )),
                                          );
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
                                    )
                                  : SizedBox(
                                      height: 30,
                                      width: 30,
                                    ),
                              leading: Checkbox(
                                value: state.todos[index]['isDone'] ?? false,
                                onChanged: (value) {
                                  // update to do
                                  _todoHomeBloc.add(
                                    TodoHomeUpdateEvent(
                                      id: state.todos[index]['id'] ?? '',
                                      isDone: value ?? false,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Updating ...',
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }
              },
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: NeoPopButton(
              color: kSecondaryColor,
              bottomShadowColor:
                  ColorUtils.getVerticalShadow(kGreyColor).toColor(),
              rightShadowColor:
                  ColorUtils.getHorizontalShadow(kGreyColor).toColor(),
              animationDuration: const Duration(milliseconds: 100),
              depth: 4,
              onTapUp: () {
                // bottom sheet
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0),
                        topLeft: Radius.circular(0)),
                  ),
                  builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: NeoPopButton(
                        topShadowColor: kGreyColor,
                        color: kWhiteColor,
                        border: const Border(
                          top: BorderSide(
                            color: kGreyColor,
                            width: 6,
                          ),
                        ),
                        buttonPosition: Position.fullBottom,
                        depth: 4,
                        child: Container(
                          color: Colors.white,
                          child: BlocProvider.value(
                            value: _todoHomeBloc,
                            child: const AddTodoView(),
                          ),
                        ),
                      )),
                );
              },
              border: Border.all(
                color: kSecondaryColor,
                width: 1,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Add To Do",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    SizedBox(width: 5),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
