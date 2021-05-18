// Author: Faith Reeves
// Assignment: Assign8
// Date completed: 04/11/2021
// Time spent on program: 7 hrs
// Operating System: Windows 10
// IDE: IntelliJ
// Purpose: User enters their name, an upper bound, and a lower bound. The
//          program checks a data set file for values within those bounds and
//          then writes them to a new file named after the user. The program tells
//          the what their file is named and what percentage of values were left
//          in the data set file (not written into their file).
//
// Note: Run in the terminal using the command below (with appropriate file path):
// dart numberTransfer.dart "C:\Users\faith\OneDrive\Documents\Programming Languages\Assignments\Assign8\dataSet.txt"

import 'dart:convert';
import 'dart:io';

// pass file path containing the data set to mein method
main(List<String> args) async {

  // store file path here
  String path = args[0];

  // create File object with given path
  File file = new File(path);

  // create a list to hold every file value
  List originalValues = new List.filled(0, null, growable: true);

  // create a list to hold all file values in the given range
  List rangeValues = new List.filled(0, null, growable: true);

  // prepare to read file contents
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8
      .transform(LineSplitter());    // Convert stream to individual lines

  // go through file and write number to original values list
  await for (var num in lines) {

    originalValues.add(num);
  }

  // store number of values that were in the file
  int length = originalValues.length;

  // call method to get users name and create the name for the users file
  String fileName = newFileName();

  // create file object for users file
  File usersFile = File(fileName);

  // prompt user for lower bound
  print('\nEnter a lower bound: ');

  // read in and store upper bound
  double lowerBound = double.parse(stdin.readLineSync().toString());

  // prompt user for upper bound
  print('\nEnter an upper bound: ');

  // read in and store upper bound
  double upperBound = double.parse(stdin.readLineSync().toString());

  // exit program if bound values are invalid
  if(lowerBound > upperBound) {

    print('Lower bound cannot be less than upper bound. Exiting program.');

    exit(1);
  }

  // iterate through each number in the list
  for(int i = 0; i < length; i++) {

    // store value as a double
    double number = double.parse(originalValues[i]);

    // if the number is in the range, execute if statement
    if((number >= lowerBound) & (number <= upperBound)) {

      // add to range list
      rangeValues.add(number);

      // remove from original list
      originalValues.removeAt(i);

      // decrement length var
      length--;
    }
  };

  // open the IOSink
  var sink = usersFile.openWrite();

  // write range list values to user's file
  rangeValues.forEach((number) {

    // write rounded value into users file
    sink.write(number.toStringAsFixed(2) + "\n");
  });

  // Close the IOSink to free system resources
  sink.close();

  // length of the original list
  int oldLength = originalValues.length + rangeValues.length;

  // compute percentage of values remaining in the original list
  String valuesLeft = (((length * 1.0) / (oldLength * 1.0)) * 100).toStringAsFixed(2);

  // print ending message
  print('The values in-between $lowerBound and $upperBound were written to '
        '\"$fileName\".\n$valuesLeft% of the values from the data set were NOT '
        'written to \"$fileName\".\nAll done!');
}

// prompts user for name and returns users new file name
String newFileName() {

  // prompt user for first name
  print('Enter your first name: ');

  // read in and store first name
  String firstName = stdin.readLineSync().toString();

  // prompt user for last name
  print('\nEnter your last name: ');

  // read in and store last name
  String lastName = stdin.readLineSync().toString();

  // create user's data file
  String name = '$firstName$lastName' + 'Numbers.txt';

  return name;
}
