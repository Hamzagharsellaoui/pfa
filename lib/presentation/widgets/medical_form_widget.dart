import 'package:flutter/material.dart';

class MedicalFormWidget extends StatefulWidget {
  const MedicalFormWidget({Key? key}) : super(key: key);

  @override
  _MedicalFormWidgetState createState() => _MedicalFormWidgetState();
}

class _MedicalFormWidgetState extends State<MedicalFormWidget> {
  String gender = "Male";
  double height = 180;
  double weight = 70;
  DateTime? dateOfBirth;
  final nameController = TextEditingController(text: "Hamza Gharsellaoui");
  final emailController = TextEditingController(text: "Hamza.gharsellaoui@enis.tn");
  final phoneController = TextEditingController(text: "99 999 999");
  final complaintController = TextEditingController(text: "My tummy hurts for no reason :(");

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Bio"),

          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Full Name"),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          Row(
            children: [
              Text("+216"),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Phone Number"),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),
          Text("Physical Information"),

          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text("Male"),
                  value: "Male",
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text("Female"),
                  value: "Female",
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                ),
              ),
            ],
          ),

          Text("Height: ${height.toInt()} cm"),
          Slider(
            value: height,
            min: 120,
            max: 200,
            divisions: 80,
            label: "${height.toInt()}",
            onChanged: (value) => setState(() => height = value),
          ),

          Text("Weight: ${weight.toInt()} kg"),
          Slider(
            value: weight,
            min: 60,
            max: 80,
            divisions: 20,
            label: "${weight.toInt()}",
            onChanged: (value) => setState(() => weight = value),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Date of Birth"),
            subtitle: Text(
              dateOfBirth != null
                  ? "${dateOfBirth!.toLocal()}".split(' ')[0]
                  : "Select your birth date",
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2025, 1, 24),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => dateOfBirth = picked);
              }
            },
          ),

          SizedBox(height: 24),
          Text("Additional Comments"),
          TextFormField(
            controller: complaintController,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Main Complaint",
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 12),
          Text("Complaint Photo (Optional)"),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {}, // TODO: implement photo logic
                icon: Icon(Icons.camera_alt),
                label: Text("Take Photo"),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {}, // TODO: implement upload logic
                icon: Icon(Icons.upload_file),
                label: Text("Upload"),
              ),
            ],
          ),

          SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Handle submission
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.deepPurple,
              ),
              child: Text("Continue →", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
