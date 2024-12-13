



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/size_constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> items = List.generate(10, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConstant.getHeightWithScreen(16),
              vertical: MediaQuery.of(context).viewPadding.top),
          child:  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 100,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    items[index],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
