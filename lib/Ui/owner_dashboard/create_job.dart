import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:justconnect/constants/color_constants.dart';
import 'package:justconnect/constants/size_constants.dart';
import 'package:justconnect/constants/strings.dart';
import 'package:justconnect/controller/owner_controller.dart';
import 'package:justconnect/widget/common_button.dart';
import 'package:justconnect/widget/commontextInputfield.dart';

class CreateJob extends StatefulWidget {
  final String ownerImage;
  final String ownerName;
  const CreateJob(
      {super.key, required this.ownerImage, required this.ownerName});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  final OwnerController _ownerController = Get.put(OwnerController());

  @override
  void initState() {
    _ownerController.nameController.text = widget.ownerName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        title: Text(
          Strings.createJob,
          style: TextStyle(
              color: ColorConstant.white,
              fontSize: SizeConstant.largeFont,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.only(
              left: SizeConstant.horizontalPadding,
              right: SizeConstant.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              Container(
                width: SizeConstant.getHeightWithScreen(80),
                height: SizeConstant.getHeightWithScreen(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstant.primaryColor,
                    width: SizeConstant.getHeightWithScreen(1),
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.ownerImage,
                    fit: BoxFit.cover,
                    width: SizeConstant.getHeightWithScreen(40),
                    height: SizeConstant.getHeightWithScreen(40),
                  ),
                ),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              CommonTextInputField(
                textInputType: TextInputType.number,
                showLabel: false,
                height: SizeConstant.getHeightWithScreen(50),
                controller: _ownerController.faltNoController,
                hintText: "Enter Flat No.",
                isAteriskRequired: false,
                enableInteractiveSelection: false,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(10)),
              GestureDetector(
                onTap: () async {
                  await selectDate(_ownerController.dateController, (value) {});
                  setState(() {});
                },
                child: Container(
                  height: SizeConstant.getHeightWithScreen(50),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorConstant.tfDisabledBorderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                    left: SizeConstant.getHeightWithScreen(16),
                    top: SizeConstant.getHeightWithScreen(4),
                    bottom: SizeConstant.getHeightWithScreen(4),
                  ),
                  child: AbsorbPointer(
                    child: TextField(
                      readOnly: true,
                      controller: _ownerController.dateController,
                      style: TextStyle(
                        color: ColorConstant.tfTextColor,
                        fontSize: SizeConstant.smallFont,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Date",
                          suffixIcon: Icon(Icons.calendar_today_rounded,
                              color: ColorConstant.grey7,
                              size: SizeConstant.getHeightWithScreen(20)),
                          labelStyle: TextStyle(
                            color: ColorConstant.textFieldHintColor,
                            fontSize: SizeConstant.smallFont,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(10)),
              CommonTextInputField(
                textInputType: TextInputType.text,
                showLabel: false,
                height: SizeConstant.getHeightWithScreen(50),
                controller: _ownerController.typeController,
                hintText: "Enter Type of Job",
                isAteriskRequired: false,
                enableInteractiveSelection: false,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(10)),
              CommonTextInputField(
                textInputType: TextInputType.text,
                showLabel: false,
                isDisabled: true,
                height: SizeConstant.getHeightWithScreen(50),
                controller: _ownerController.nameController,
                hintText: "Enter Name",
                isAteriskRequired: false,
                enableInteractiveSelection: false,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: SizeConstant.getHeightWithScreen(20)),
              CommonButton(
                  bgColor: ColorConstant.outletButtonColor,
                  btnHeight: SizeConstant.getHeightWithScreen(48),
                  onTap: () {
                    if(_ownerController.faltNoController.text.isNotEmpty && _ownerController.dateController.text.isNotEmpty && _ownerController.typeController.text.isNotEmpty && _ownerController.nameController.text.isNotEmpty){
                      
                    }
                    // String pattern =
                    //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    // RegExp regex = RegExp(pattern);
                    // if (!regex.hasMatch(emailController.text.trim())) {
                    //   Get.to(() => const Home());
                    // }
                  },
                  label: Strings.submit),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(
      TextEditingController controller, Function(String) onDateChanged) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateChanged(formatter.format(picked));
      controller.text = formatter.format(picked);
    }
  }
}
