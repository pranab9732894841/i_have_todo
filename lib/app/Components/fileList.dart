import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:i_have_todo/app/constants/them_data.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:open_file_plus/open_file_plus.dart';

import 'package:path_provider/path_provider.dart';

class FilesViewUrl extends StatefulWidget {
  final List<String> files;
  const FilesViewUrl({
    Key? key,
    required this.files,
  }) : super(key: key);

  @override
  State<FilesViewUrl> createState() => _FilesViewUrlState();
}

class _FilesViewUrlState extends State<FilesViewUrl> {
  List<File> files = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  // void loadFiles() async {
  //   for (var url in widget.files) {
  //     log(url);
  //     final file = await DefaultCacheManager().getSingleFile(
  //       url,
  //     );
  //     log(file.path);
  //     files.add(file);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  void loadFiles() async {
    for (var url in widget.files) {
      final file = await getFileFromUrl(url);
      files.add(file);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<File> getFileFromUrl(String url, {name}) async {
    String f = url.split('?').first;
    String fileName = f.split('/').last;
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  String getExtension(String fileName) {
    return '.${fileName.split('.').last}';
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            height: 300,
            child: Center(
              child: SpinKitWave(
                color: kPrimaryColor,
                type: SpinKitWaveType.start,
                size: 20,
              ),
            ))
        : Container(
            height: 400,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Attached Files',
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
                Expanded(
                  child: SingleChildScrollView(
                      child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    children: files.map((e) => _buildFile(e)).toList(),
                  )),
                ),
              ],
            ),
          );
  }

  Widget _buildFile(File file) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
      ),
      child: NeoPopButton(
        color: kWhiteColor,
        parentColor: Colors.transparent,
        buttonPosition: Position.center,
        onTapUp: () async {
          HapticFeedback.vibrate();
          await OpenFile.open(file.path).catchError((e) {
            log(e.toString());
          });
        },
        onTapDown: () {
          HapticFeedback.vibrate();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/icons/file.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    right: 20,
                    child: Container(
                      child: Text(
                        getExtension(file.path),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: kWhiteColor,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    deleteFiles(files);
  }

  Future<void> deleteFiles(List<File> file) async {
    for (var f in file) {
      await f.delete().whenComplete(() => log('file deleted'));
    }
  }
}
