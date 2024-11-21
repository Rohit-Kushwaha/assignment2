import 'package:cash_denomination/database.dart';
import 'package:cash_denomination/dialog.dart';
import 'package:cash_denomination/viewmodel.dart';
import 'package:cash_denomination/widgets/build_banner.dart';
import 'package:cash_denomination/widgets/custom_row.dart';
import 'package:cash_denomination/widgets/simple_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_to_words_english/number_to_words_english.dart';

class DenominationScreen extends StatefulWidget {
  const DenominationScreen({super.key, this.recordId});
  final int? recordId;

  @override
  State<DenominationScreen> createState() => _DenominationScreenState();
}

class _DenominationScreenState extends State<DenominationScreen> {
  final DenominationViewModel _viewModel = DenominationViewModel();
  final Map<String, TextEditingController> controllers = {};
  final ValueNotifier<List<String>> _inputFields =
      ValueNotifier<List<String>>([]);
  bool _showTwoButtons = false;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    for (var key in _viewModel.denominations.keys) {
      controllers[key] = TextEditingController();
      controllers[key]!.addListener(() {
        _viewModel.updateDenomination(key, controllers[key]!.text);
        _updateInputFields();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    _viewModel.dispose();
    _inputFields.dispose();
    super.dispose();
  }

  // Update the list of input fields with non-empty values
  void _updateInputFields() {
    final fieldsWithText = controllers.values
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toList();
    _inputFields.value = fieldsWithText;
  }

  // Convert the total amount to words
  String convertAmountToText(int amount) {
    return NumberToWordsEnglish.convert(amount)
        .replaceAll('-', ' ') // Replace hyphens with spaces
        .split(' ') // Split by spaces
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' '); // Replace with actual conversion logic
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _viewModel.calculateTotalAmount();
    final totalAmountInWords = convertAmountToText(totalAmount);
   FocusNode _focusNode = FocusNode();
    return Scaffold(
      backgroundColor: Colors.black45,
      body: GestureDetector(
        onTap: () {
          // Hide the two buttons when tapping anywhere on the screen
           if (!_focusNode.hasFocus && _showTwoButtons) {
            setState(() {
              _showTwoButtons = false;
            });
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header section with dynamic display based on input
                  ValueListenableBuilder<List<String>>(
                    valueListenable: _inputFields,
                    builder: (context, inputFields, child) {
                      if (inputFields.isNotEmpty) {
                        return buildBanner(context, totalAmount,
                            totalAmountInWords); // Show header when there is any input
                      } else {
                        return buildSimpleBanner(
                            context); // Show simple banner when no input
                      }
                    },
                  ),
                  // Denomination rows
                  ..._viewModel.denominations.keys.map((key) {
                    return buildDenominationRow(
                      key,
                      controllers[key]!,
                      _viewModel.denominations[key]!,
                    );
                  }),
                ],
              ),
            ),
            // Button that appears when any TextField has input
            ValueListenableBuilder<List<String>>(
              valueListenable: _inputFields,
              builder: (context, inputFields, child) {
                return inputFields.isNotEmpty
                    ? Positioned(
                        right: 20.w,
                        bottom: 20.h,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showTwoButtons =
                                  !_showTwoButtons; // Toggle the visibility of the two buttons
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.all(20.r),
                          ),
                          child: Icon(Icons.flash_auto_outlined, size: 30.r),
                        ),
                      )
                    : const SizedBox
                        .shrink(); // Hide button when no TextField has input
              },
            ),
            // Display two buttons above the main button when _showTwoButtons is true
            if (_showTwoButtons)
              Positioned(
                right: 20.w,
                bottom: 120
                    .h, // Adjust this to position the buttons above the main button
                child: Column(
                  children: [
                    SizedBox(
                      width: 120.w,
                      height: 80.h,
                      child: Row(
                        children: [
                          Container(
                            height: 25.h,
                            width: 38.w,
                            decoration:
                                const BoxDecoration(color: Colors.black12),
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            height: 60.h,
                            child: ElevatedButton(
                                onPressed: () {},
                                child: const Icon(Icons.clear)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 120.w,
                      height: 60.h,
                      child: Row(
                        children: [
                          Container(
                            height: 25.h,
                            width: 38.w,
                            decoration:
                                const BoxDecoration(color: Colors.black12),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            height: 60.h,
                            child: ElevatedButton(
                                onPressed: () {
                                  _openDialog(context);
                                },
                                child: const Icon(Icons.save)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    final denominationQuantities = controllers.map((key, controller) {
      return MapEntry(key, controller.text);
    });
    final totalAmount = _viewModel.calculateTotalAmount();
    showDialog(
      context: context,
      builder: (context) => AddDenominationDialog(
        denominationQuantities: denominationQuantities,
        totalAmount: totalAmount,
      ),
    ).then((_) {
      // After closing the dialog, clear the text fields and reset the view model
      for (var controller in controllers.values) {
        controller.clear(); // Clear all the text fields
      }
      // Reset the denominations in the view model
      // Reset the list of input fields
      // setState(() {}); // Trigger a rebuild to update the UI
    });
  }
}
