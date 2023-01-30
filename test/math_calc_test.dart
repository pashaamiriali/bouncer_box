import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should give the result based on input string", () {
    var sample1 = "312+534";
    var sample2 = "312-534+312-534";
    var sample3 = "312+534*7/2";
    var sample4 = "54+(43-2)*43";
    var sample5 = "54+(43-2+(4-2))*43";
    var sample6 = "-5+4*(50+2)";
    expect(operationOfStrings(sample1), 846); //passed
    expect(operationOfStrings(sample2), -444); //passed
    expect(operationOfStrings(sample3), 2181); //passed
    expect(operationOfStrings(sample4), 1817); //passed
    expect(operationOfStrings(sample5), 1903); //passed
    expect(operationOfStrings(sample6), 203); //passed
  });
}

double operationOfStrings(String input) {
  String clearedInput = input.replaceAll(' ', '');
  String pResult = calculateParenthesis(clearedInput);
  String mDResult = calculateMulDiv(pResult);
  String aSResult = calculateAddSub(mDResult);
  double result = double.parse(aSResult);
  return result;
}

String calculateParenthesis(String input) {
  String given = input;
  if (!(given.contains('(') && given.contains(')'))) {
    return given;
  }
  int openingPIndex = given.lastIndexOf('(');
  int closingPIndex = given.indexOf(')');

  String subGiven = given.substring(openingPIndex + 1, closingPIndex);
  String result = calculateMulDiv(subGiven);
  result = calculateAddSub(result);
  given = given.replaceFirst('($subGiven)', result);

  return calculateParenthesis(given);
}

String calculateMulDiv(String input) {
  String given = input;
  if (!(given.contains('/') || given.contains('*'))) {
    return given;
  }
  int indexOfDiv = given.indexOf('/');
  int indexOfMul = given.indexOf('*');
  if (indexOfDiv < indexOfMul && indexOfDiv > 0 || indexOfMul == -1) {
    given = performSingleOperationOnInput(given, '/', indexOfDiv);
  } else if (indexOfMul != -1) {
    given = performSingleOperationOnInput(given, '*', indexOfMul);
  }
  return calculateMulDiv(given);
}

String calculateAddSub(String input) {
  String given = input;
  if (!(given.contains('-') || given.contains('+'))) {
    return given;
  }
  int indexOfSub = given.indexOf('-');
  int indexOfAdd = given.indexOf('+');
  bool firstNumNegative = indexOfSub == 0;
  if (firstNumNegative) {
    indexOfSub = given.indexOf('-', 1);
    var subGiven = given.substring(1);
    if (isNumeric(subGiven)) {
      return given;
    }
  }

  if (indexOfSub < indexOfAdd && indexOfSub > 0 || indexOfAdd == -1) {
    given = performSingleOperationOnInput(given, '-', indexOfSub,
        firstNumNegative: firstNumNegative);
  } else if (indexOfAdd != -1) {
    given = performSingleOperationOnInput(given, '+', indexOfAdd,
        firstNumNegative: firstNumNegative);
  }
  return calculateAddSub(given);
}

String performSingleOperationOnInput(
    String input, String operation, int indexOfOP,
    {bool firstNumNegative = false}) {
  String beforeOpNum = "";
  String afterOpNum = "";
  String result = "";
  String given = input;
  if (firstNumNegative) {
    given = given.substring(1);
    indexOfOP -= 1;
  }
  beforeOpNum = getBeforeOpNum(indexOfOP, given);
  afterOpNum = getAfterOpNum(indexOfOP, given);
  int iBeforeNum = int.parse(beforeOpNum);
  if (firstNumNegative && (indexOfOP - beforeOpNum.length) == 0) {
    iBeforeNum *= -1;
  }
  int iAfterNum = int.parse(afterOpNum);
  result = perFormOperationBasedOnType(operation, iBeforeNum, iAfterNum);
  given = given.replaceFirst(beforeOpNum + operation + afterOpNum, result);
  return given;
}

String getBeforeOpNum(int indexOfOP, String given) {
  String result = "";
  for (int i = indexOfOP - 1; i > -1; i -= 1) {
    var tempNum = given[i];
    if (isNumeric(tempNum)) {
      result = tempNum += result;
    } else {
      break;
    }
  }
  return result;
}

String getAfterOpNum(int indexOfOP, String given) {
  String result = "";
  for (int i = indexOfOP + 1; i < given.length; i += 1) {
    var tempNum = given[i];
    if (isNumeric(tempNum)) {
      result += tempNum;
    } else {
      break;
    }
  }
  return result;
}

String perFormOperationBasedOnType(
    String operation, int iBeforeNum, int iAfterNum) {
  String result = "";
  switch (operation) {
    case '+':
      result = (iBeforeNum + iAfterNum).toString();
      break;
    case '-':
      result = (iBeforeNum - iAfterNum).toString();
      break;
    case '*':
      result = (iBeforeNum * iAfterNum).toString();
      break;
    case '/':
      result = (iBeforeNum / iAfterNum).toString();
      break;
  }
  return result;
}

bool isNumeric(String char) {
  if (char.isEmpty) {
    return false;
  } else {
    try {
      double.parse(char);
      return true;
    } catch (_) {
      return false;
    }
  }
}
