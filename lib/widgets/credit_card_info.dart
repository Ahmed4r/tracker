import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final TextEditingController cardHolderNameController;
  final VoidCallback onSubmit;

  const CreditCardForm({
    Key? key,
    required this.formKey,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.cardHolderNameController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to update the UI
    widget.cardNumberController.addListener(_updateUI);
    widget.expiryDateController.addListener(_updateUI);
    widget.cvvController.addListener(_updateUI);
    widget.cardHolderNameController.addListener(_updateUI);
  }

  @override
  void dispose() {
    // Remove listeners to avoid memory leaks
    widget.cardNumberController.removeListener(_updateUI);
    widget.expiryDateController.removeListener(_updateUI);
    widget.cvvController.removeListener(_updateUI);
    widget.cardHolderNameController.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    // Call setState to rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: SizedBox(
          height: 300.h,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: widget.cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  // Update the UI dynamically
                  suffixIcon: widget.cardNumberController.text.isNotEmpty
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (value.length != 19) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0.h),
              TextFormField(
                controller: widget.expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  // Update the UI dynamically
                  suffixIcon: widget.expiryDateController.text.isNotEmpty
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  ExpiryDateInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your expiry date';
                  }
                  if (value.length != 5) {
                    return 'Expiry date must be in MM/YY format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0.h),
              TextFormField(
                controller: widget.cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                  // Update the UI dynamically
                  suffixIcon: widget.cvvController.text.isNotEmpty
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CVV';
                  }
                  if (value.length != 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0.h),
              TextFormField(
                controller: widget.cardHolderNameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                  // Update the UI dynamically
                  suffixIcon: widget.cardHolderNameController.text.isNotEmpty
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0.h),
              ElevatedButton(
                onPressed: widget.onSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Add a space after every 4 digits
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/'); // Add a slash after MM
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}