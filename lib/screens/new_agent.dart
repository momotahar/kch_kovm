import 'package:flutter/material.dart';
import 'package:kch_kovm/database/database_helper.dart';
import 'package:kch_kovm/tap_bar.dart';
import 'package:kch_kovm/utils/build_head_container.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:kch_kovm/utils/build_text_form_field.dart';
import '../../models/agent.dart';

class NewAgentScreen extends StatefulWidget {
  const NewAgentScreen({super.key});

  @override
  State<NewAgentScreen> createState() => Declaration();
}

class Declaration extends State<NewAgentScreen> {
  //Initialize DbHelper
  DatabaseHelper databaseHelper = DatabaseHelper();
  //Declaration
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController surnameCtrl = TextEditingController();
  TextEditingController matriculeCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    surnameCtrl.dispose();
    matriculeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: homeButton(context, 'Nouvel Agent'),
          backgroundColor: Colors.blue),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 40, top: 50, right: 40, bottom: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                customContainer('Nouvel Agent'),
                const SizedBox(height: 14),
                buildTextFormField(nameCtrl, 'Nom', Icons.person_outline),
                const SizedBox(height: 14),
                buildTextFormField(surnameCtrl, 'Prénom', Icons.person_outline),
                const SizedBox(height: 14),
                buildTextFormField(
                    matriculeCtrl, 'Matricule', Icons.person_outline),
                const SizedBox(height: 20),
                buildSubmitButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            if (_formKey.currentState!.validate()) {
              AgentModel newAgent = AgentModel(
                name: (nameCtrl.text).toUpperCase(),
                surname: (surnameCtrl.text)[0].toUpperCase() +
                    (surnameCtrl.text).substring(1),
                matricule: matriculeCtrl.text,
              );

              databaseHelper.newAgent(newAgent.toJson());

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TapBar()),
                  (route) => false);
              clear();
            }
          } catch (e) {
            throw Exception(e);
          }
        },
        style: buildStyle(Colors.blueAccent, 150, 50),
        child: const Text(
          'Valider',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

// clear Fields
  clear() {
    nameCtrl.clear();
    surnameCtrl.clear();
    matriculeCtrl.clear();
  }
}
