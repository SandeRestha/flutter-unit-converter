import 'package:flutter/material.dart';

// Entry point of the app
void main() => runApp(UnitConverterApp());

// The main app widget
class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets general color theme
      ),
      home: ConverterHome(), // Loads the home screen
    );
  }
}

// Stateful widget to handle dynamic UI and user interaction
class ConverterHome extends StatefulWidget {
  const ConverterHome({super.key});
  @override
  State<ConverterHome> createState() => _ConverterHomeState();
}

class _ConverterHomeState extends State<ConverterHome> {
  // Controller to handle input from the text field
  final TextEditingController _inputController = TextEditingController();

  // Default category and unit selections
  String _selectedCategory = 'Distance';
  String _fromUnit = 'Miles';
  String _toUnit = 'Kilometers';

  // Stores the result and original input value
  double _convertedValue = 0.0;
  double? _inputValue;

  // Available unit categories and options
  final Map<String, List<String>> _unitOptions = {
    'Distance': ['Miles', 'Kilometers'],
    'Weight': ['Pounds', 'Kilograms'],
  };

  // Function to perform unit conversion
  void _convert() {
    double input = double.tryParse(_inputController.text) ?? 0.0;
    double result = 0.0;

    // Handle distance conversion logic
    if (_selectedCategory == 'Distance') {
      if (_fromUnit == 'Miles' && _toUnit == 'Kilometers') {
        result = input * 1.60934;
      } else if (_fromUnit == 'Kilometers' && _toUnit == 'Miles') {
        result = input / 1.60934;
      } else {
        result = input; // same unit
      }
    }

    // Handle weight conversion logic
    else if (_selectedCategory == 'Weight') {
      if (_fromUnit == 'Pounds' && _toUnit == 'Kilograms') {
        result = input * 0.453592;
      } else if (_fromUnit == 'Kilograms' && _toUnit == 'Pounds') {
        result = input / 0.453592;
      } else {
        result = input; // same unit
      }
    }

    // Update UI with converted value
    setState(() {
      _inputValue = input;
      _convertedValue = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the unit list for the selected category
    List<String> units = _unitOptions[_selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Measures Converter'),
        centerTitle: true,              
        backgroundColor: Colors.blue,   
        foregroundColor: Colors.white,  
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Apply padding around content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select category (Distance or Weight)
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _unitOptions.keys
                  .map((category) =>
                      DropdownMenuItem(
                        value: category, 
                        child: Text(category, style: TextStyle(color: Colors.blue),)
                      )
                    )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  // Reset unit options when category changes
                  _fromUnit = _unitOptions[value]![0];
                  _toUnit = _unitOptions[value]![1];
                  _convert(); // Update result with new units
                });
              },
            ),

            SizedBox(height: 20),

            // Centered "Value" label
            Center(
              child: Text(
                'Value', 
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),

            // Input field for entering value
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter a number',
              ),
            ),

            SizedBox(height: 20),

            // Centered "From" label
            Center(
              child: Text(
                'From', 
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),

            // Dropdown to select the "from" unit
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              items: units
                  .map((unit) =>
                      DropdownMenuItem(
                        value: unit, 
                        child: Text(unit, style: TextStyle(color: Colors.blue))
                      )
                    )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _fromUnit = value!;
                  _convert(); // Recalculate on unit change
                });
              },
            ),

            SizedBox(height: 20),

            // Centered "To" label
            Center(
              child: Text(
                'To', 
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),

            // Dropdown to select the "to" unit
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              items: units
                  .map((unit) =>
                      DropdownMenuItem(
                        value: unit, 
                        child: Text(unit, style: TextStyle(color: Colors.blue))
                      )
                    )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toUnit = value!;
                  _convert(); // Recalculate on unit change
                });
              },
            ),

            SizedBox(height: 30),

            // Button to perform conversion
            Center(
              child: ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text(
                  'Convert',
                  style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Display the conversion result
            Center(
              child: Text(
                _inputValue != null
                    ? '${_inputValue!.toStringAsFixed(1)} $_fromUnit are ${_convertedValue.toStringAsFixed(3)} $_toUnit'
                    : '',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
