import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildDenominationRow(
  String denomination,
  TextEditingController controller,
  ValueNotifier<int> notifier,
) {
  return SizedBox(
    height: 80.h,
    width: 400.w,
    child: Row(
      children: [
        SizedBox(
          width: 50.w,
          child: Text(
            denomination,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 10.w),
        const Text(
          'X',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(width: 20.w),
        SizedBox(
          height: 50.h,
          width: 180.w,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 10.w,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        controller.clear(); // Clear the text
                      },
                    )
                  : null, // Show nothing when the field is empty
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (context, result, child) {
            return SizedBox(
              width: 100.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "= ₹ ${result.toString()}",
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
