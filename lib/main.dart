import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: LoanCalculator(),
  ));
}

class LoanCalculator extends StatefulWidget {
  @override
  _LoanCalculatorState createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  double loanAmount = 0000;
  double interestRate = 0.0;
  double loanTermInYears = 0;
  double monthlyPayment = 0.0;
  double totalInterest = 0.0;
  int totalPayments = 0;
  double totalAmountPayments = 0.0;

  final loanAmountController = TextEditingController();
  final interestRateController = TextEditingController();
  final loanTermController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loanAmountController.text = loanAmount.toString();
    interestRateController.text = interestRate.toString();
    loanTermController.text = loanTermInYears.toString();
  }

  void calculateMonthlyPayment() {
    setState(() {
      loanAmount = double.parse(loanAmountController.text);
      interestRate = double.parse(interestRateController.text);
      loanTermInYears = double.parse(loanTermController.text);

      // Convert years to months for the calculation
      int loanTermInMonths = (loanTermInYears * 12).toInt();
      double monthlyInterestRate = (interestRate / 100) / 12;
      monthlyPayment =
          (loanAmount * monthlyInterestRate) /
              (1 - pow(1 + monthlyInterestRate, -loanTermInMonths));

      totalInterest = (monthlyPayment * loanTermInMonths) - loanAmount;
      totalPayments = loanTermInMonths;
      totalAmountPayments = monthlyPayment * totalPayments;
    });
  }

  @override
  void dispose() {
    loanAmountController.dispose();
    interestRateController.dispose();
    loanTermController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  String? loanAmountError;
  String? interestRateError;
  String? loanTermError;

  void clearErrors() {
    setState(() {
      loanAmountError = null;
      interestRateError = null;
      loanTermError = null;
    });
  }

  void clearFields() {
    setState(() {
      loanAmountController.clear();
      interestRateController.clear();
      loanTermController.clear();
      monthlyPayment = 0.0;
      totalInterest = 0.0;
      totalPayments = 0;
      totalAmountPayments = 0.0;
      loanTermInYears = 0.0;
    });
  }

  void calculateMonthlyPayment() {
    clearErrors(); // Clear any previous errors

    double? parsedLoanAmount;
    double? parsedInterestRate;
    double? parsedLoanTerm;

    try {
      parsedLoanAmount = double.parse(loanAmountController.text);
    } catch (e) {
      loanAmountError = 'Enter a valid number';
    }

    try {
      parsedInterestRate = double.parse(interestRateController.text);
    } catch (e) {
      interestRateError = 'Enter a valid number';
    }

    try {
      parsedLoanTerm = double.parse(loanTermController.text);
    } catch (e) {
      loanTermError = 'Enter a valid number';
    }

    if (parsedLoanAmount != null && parsedInterestRate != null && parsedLoanTerm != null) {
      loanAmount = parsedLoanAmount;
      interestRate = parsedInterestRate;
      loanTermInYears = parsedLoanTerm;

      // Convert years to months for the calculation
      int loanTermInMonths = (loanTermInYears * 12).toInt();
      double monthlyInterestRate = (interestRate / 100) / 12;
      monthlyPayment =
          (loanAmount * monthlyInterestRate) /
              (1 - pow(1 + monthlyInterestRate, -loanTermInMonths));

      totalInterest = (monthlyPayment * loanTermInMonths) - loanAmount;
      totalPayments = loanTermInMonths;
      totalAmountPayments = monthlyPayment * totalPayments;
    }
  }

  return Scaffold(
    appBar: AppBar(
      title: Text('Payment Calculator'),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: loanAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Loan Amount',
                errorText: loanAmountError,
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: interestRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Interest Rate (%)',
                errorText: interestRateError,
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: loanTermController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Loan Term (years)',
                errorText: loanTermError,
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: calculateMonthlyPayment,
                  child: Text('Calculate'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size(120, 43),
                  ),
                ),
                ElevatedButton(
                  onPressed: clearFields,
                  child: Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    minimumSize: Size(120, 43),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Monthly Payment: \$${monthlyPayment.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'You will need to pay \$${monthlyPayment.toStringAsFixed(2)} every month for ${loanTermInYears.toStringAsFixed(0)} years to pay off the debt',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total Interest: \$${totalInterest.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Total of $totalPayments Payments: \$${totalAmountPayments.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}