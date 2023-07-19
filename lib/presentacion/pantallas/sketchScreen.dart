import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribble/scribble.dart';

class sketchScreen extends StatefulWidget {
  const sketchScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<sketchScreen> createState() => _sketchScreenState();
}

class _sketchScreenState extends State<sketchScreen> {
  late ScribbleNotifier notifier;
  String? filePathFinal;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading:
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: "Volver a la nota",
              onPressed: () async {
                Navigator.pop(context, null);
              },
            ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5 ,
          child: Stack(
            children: [
              Scribble(
                notifier: notifier,
                drawPen: true,
              ),
              Positioned(
                top: 5,
                right: 16,
                child: Column(
                  children: [
                    _buildColorToolbar(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _saveImage(context);
          setState(() {
            
          });
        },
        tooltip: 'Guardar imagen',
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final image = await notifier.renderImage();
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text("Your Image"),
    //     content: Image.memory(image.buffer.asUint8List()),
    //   ),
    // );

    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDirectory.path;

     String path = 'sketch' + DateTime.now().toString() + '.png';
    // String tempPath = tempDir.path;
     var buffer = image.buffer;
    // var filePath = '$tempPath/$path';

    File file = await File("$appDocPath/$path").writeAsBytes(buffer.asUint8List(
      image.offsetInBytes,
      image.lengthInBytes,
    ));

    filePathFinal = file.path;

    print('Image saved to gallery.');

    Navigator.pop(context, filePathFinal);

  }

  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUndoButton(context),
          const Divider(
            height: 1.0,
          ),
          _buildRedoButton(context),
          const Divider(
            height: 1.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildPointerModeSwitcher(context,
              penMode:
                  state.allowedPointersMode == ScribblePointerMode.penOnly),
          const Divider(
            height: 6.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
          _buildColorButton(context, color: Colors.black, state: state),
          _buildColorButton(context, color: Colors.red, state: state),
          _buildColorButton(context, color: Colors.green, state: state),
          _buildColorButton(context, color: Colors.blue, state: state),
          _buildColorButton(context, color: Colors.yellow, state: state),
        ],
      ),
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context,
      {required bool penMode}) {
    return FloatingActionButton.small(
      heroTag: penMode ? "pen" : "touch",
      onPressed: () => notifier.setAllowedPointersMode(
        penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
      ),
      tooltip:
          "Cambiar modo a " + (penMode ? "todo" : "solo lapiz"),
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: !penMode
            ? const Icon(
                Icons.touch_app,
                key: ValueKey(true),
              )
            : const Icon(
                Icons.do_not_touch,
                key: ValueKey(false),
              ),
      ),
    );
  }

  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: FloatingActionButton.small(
        heroTag: "eraser",
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: notifier.setEraser,
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleState state,
  }) {
    final isSelected = state is Drawing && state.selectedColor == color.value;
    return Padding(
      padding: const EdgeInsets.all(1),
      child: FloatingActionButton.small(
          heroTag: color.value.toString(),
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildUndoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      heroTag: "undo",
      tooltip: "Undo",
      onPressed: notifier.canUndo ? notifier.undo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canUndo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.undo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRedoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      heroTag: "redo",
      tooltip: "Redo",
      onPressed: notifier.canRedo ? notifier.redo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canRedo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.redo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "clear",
      tooltip: "Clear",
      onPressed: notifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.clear),
    );
  }
}
