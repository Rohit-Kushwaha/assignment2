import 'package:cash_denomination/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildSimpleBanner(BuildContext context) {
  return Container(
    height: 200.h,
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/currency_banner.jpg'),
        fit: BoxFit.fitWidth,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 390.w, top: 50.h),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DenominationListScreen()));
            },
            child: Icon(
              Icons.menu,
              size: 30.r,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 65.h),
          child: const Text(
            'Denomination',
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
