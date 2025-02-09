import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracker/widgets/credit_card_info.dart';
import 'package:u_credit_card/u_credit_card.dart';

class CreditCardScreen extends StatefulWidget {
  static const String routeName = '/credit_card_screen';
  const CreditCardScreen({super.key});

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen for changes in the text fields
    _cardNumberController.addListener(_updateUI);
    _expiryDateController.addListener(_updateUI);
    _cvvController.addListener(_updateUI);
    _cardHolderNameController.addListener(_updateUI);
  }

  @override
  void dispose() {
    // Clean up the controllers
    _cardNumberController.removeListener(_updateUI);
    _expiryDateController.removeListener(_updateUI);
    _cvvController.removeListener(_updateUI);
    _cardHolderNameController.removeListener(_updateUI);
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _updateUI() {
    // Call setState to rebuild the UI
    setState(() {});
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      print('Card Number: ${_cardNumberController.text}');
      print('Expiry Date: ${_expiryDateController.text}');
      print('CVV: ${_cvvController.text}');
      print('Cardholder Name: ${_cardHolderNameController.text}');
    }
  }

  // Determine the card type based on the card number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0).r,
          child: Column(
            children: [
              CreditCardForm(
                formKey: _formKey,
                cardNumberController: _cardNumberController,
                expiryDateController: _expiryDateController,
                cvvController: _cvvController,
                cardHolderNameController: _cardHolderNameController,
                onSubmit: _onSubmit,
              ),
              
              CreditCardUi(
                width: double.infinity,
                topLeftColor: Colors.black,
                bottomRightColor: Colors.black,
                cardHolderFullName: _cardHolderNameController.text,
                cardNumber: _cardNumberController.text,
                validThru: _expiryDateController.text,
                cvvNumber: _cvvController.text,
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}