import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/widgets/chart.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/homepage';


   Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController title = TextEditingController();
  final TextEditingController amount = TextEditingController();
  late final Box transactionBox; // Declare the box
  late final Box settingsBox; // Declare the settings box
  File? _profileImage; // To store the selected image

  final ImagePicker _picker = ImagePicker();
  

  @override
  void initState() {
    super.initState();
    // Initialize the boxes
    transactionBox = Hive.box('transactions');
    settingsBox = Hive.box('settings');
    

    // Initialize max amount if not set
    if (settingsBox.get('maxAmount') == null) {
      settingsBox.put('maxAmount', 1000); // Default max amount
    }
    _loadProfileImage();
  }
  Future<void> _loadProfileImage() async {
  final profileImagePath = settingsBox.get('profile_image_path');
  if (profileImagePath != null) {
    setState(() {
      _profileImage = File(profileImagePath);
    });
  }
}



  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    super.dispose();
  }

  // Function to pick an image from the gallery


 Future<void> _pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final profileImagePath = await _saveImage(pickedFile);
    await settingsBox.put('profile_image_path', profileImagePath);

    setState(() {
      _profileImage = File(profileImagePath);
      log("Profile image path: $_profileImage");
    });
  }
}

Future<String> _saveImage(XFile pickedFile) async {
  final directory = await getApplicationDocumentsDirectory();
  final profileImagePath = '${directory.path}/profile_image.png';
  log(profileImagePath);
  await pickedFile.saveTo(profileImagePath);
  return profileImagePath;
}




 void _addTransaction(String title, String amount) {
  if (title.isEmpty || amount.isEmpty) {
    log("Title or amount cannot be empty");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Title or amount cannot be empty",
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    return;
  }

  final parsedAmount = double.tryParse(amount);
  if (parsedAmount == null) {
    log("Amount must be a valid number");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Amount must be a valid number",
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    return;
  }

  final double totalAmount = getTotalAmount();
  final int maxAmount = settingsBox.get('maxAmount', defaultValue: 1000);
  if (totalAmount + parsedAmount > maxAmount) {
    log("Transaction exceeds the maximum allowed amount");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Transaction exceeds the maximum allowed amount",
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    return;
  }

  setState(() {
    transactionBox.add({'title': title, 'amount': amount});
  });
}

  double getTotalAmount() {
    double total = 0;
    for (var i = 0; i < transactionBox.length; i++) {
      final transaction = transactionBox.getAt(i);
      total += double.parse(transaction['amount']);
    }
    return total;
  }

  // Function to set max amount
 Future<void> _setMaxAmount(BuildContext context) async {
  final TextEditingController maxAmountController = TextEditingController();
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Set Maximum Amount",
          style: GoogleFonts.mulish(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: maxAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Enter Maximum Amount",
            labelStyle: GoogleFonts.mulish(
              fontSize: 16.sp,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.mulish(
                fontSize: 16.sp,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final input = maxAmountController.text;
              if (input.isNotEmpty && int.tryParse(input) != null && int.parse(input) > 0) {
                setState(() {
                  settingsBox.put('maxAmount', int.parse(input));
                });
                Navigator.pop(context);
              } else {
                log("Invalid input for maximum amount");
              }
            },
            child: Text(
              "Save",
              style: GoogleFonts.mulish(
                fontSize: 16.sp,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    final int maxAmount = settingsBox.get('maxAmount', defaultValue: 50000);
    final double totalAmount = getTotalAmount();
    final double availableBalance = maxAmount - totalAmount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: _pickImage, 
            child:  CircleAvatar(
  radius: 30.r,
  backgroundImage: _profileImage != null
      ? FileImage(_profileImage!)
      : const AssetImage("assets/frame.png") as ImageProvider,
  child: _profileImage == null
      ? const Icon(
          Icons.person,
          color: Colors.white,
        )
      : null,
),
          ),
        ],
        title: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (context, Box box, _) {
          final String name = box.get('name', defaultValue: 'User');
          return Text(
            "Hi, $name",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
              color: Colors.white,
            ),
          );}),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.all(20.w),
              height: 106.h,
              width: 340.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 24, 39, 47),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: GoogleFonts.mulish(
                          fontSize: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "$availableBalance/$maxAmount",
                            style: GoogleFonts.mulish(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w), // Add some spacing
                          IconButton(
                            icon: const Icon(
                              Icons.edit, // Pencil icon
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _setMaxAmount(context), // Open the dialog
                          ),
                        ],
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * (3 / 4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              border: Border.all(color: Colors.grey, width: 0.2.w),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 40.h),
                                Text(
                                  "Add Transaction",
                                  style: GoogleFonts.mulish(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                TextField(
                                  style: GoogleFonts.monda(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                  controller: title,
                                  decoration: InputDecoration(
                                    labelText: "Enter Title",
                                    labelStyle: GoogleFonts.mulish(
                                      fontSize: 20.sp,
                                      color: Colors.white,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.monda(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                  controller: amount,
                                  decoration: InputDecoration(
                                    labelText: "Amount",
                                    labelStyle: GoogleFonts.mulish(
                                      fontSize: 20.sp,
                                      color: Colors.white,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                InkWell(
                                  onTap: () {
                                    if (amount.text.isEmpty || title.text.isEmpty) {
                                      log("Title or amount cannot be empty");
                                      return;
                                    }

                                    if (double.tryParse(amount.text) == null) {
                                      log("Amount must be a valid number");
                                      return;
                                    }

                                    log("Transaction added");
                                    _addTransaction(title.text, amount.text);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      gradient: const LinearGradient(
                                        colors: [Colors.blue, Colors.green],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Add",
                                        style: GoogleFonts.mulish(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    backgroundColor: Colors.blueGrey,
                    child: const FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const LineChartSample2(),
            const Divider(color: Colors.white),
            SizedBox(height: 10.h),
            Text(
              "Recent Transactions",
              style: GoogleFonts.mulish(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            ValueListenableBuilder(
              valueListenable: transactionBox.listenable(),
              builder: (context, Box box, _) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final transaction = box.getAt(index);
                    return ListTile(
                      title: Text(
                        transaction['title'],
                        style: GoogleFonts.mulish(
                          fontSize: 20.sp,
                          color: Colors.orange,
                        ),
                      ),
                      subtitle: Text(
                        transaction['amount'],
                        style: GoogleFonts.mulish(
                          fontSize: 16.sp,
                          color: Colors.cyan,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            box.deleteAt(index);
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}