import 'package:cash_denomination/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildBanner(
    BuildContext context, int totalAmount, String totalAmountInWords) {
  return Container(
    height: 200.h,
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/currency_banner.jpg'),
        fit: BoxFit.fitWidth,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 380.w, top: 50.h),
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
          SizedBox(height: 10.h),
          const Text(
            'Total Amount',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          Text(
            "₹${totalAmount.toString()}",
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            "$totalAmountInWords/-",
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
  );
}
