import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:statefulclickcounter/definitions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _username = '';
  String _name = '';
  String _address = '';
  DateTime _birthdate = DateTime(0000, 00, 00);
  String _phoneNumber = '';
  String _email = '';
  String _maritalStatus = 'Belum';
  String _gender = 'Laki-laki';

  void handleSubmit() async {
    try {
      print('handled');
      final request = UserData(_password, _username, _name, _gender, _address,
          _birthdate, _phoneNumber, _email, _maritalStatus);
      final url = Uri.parse('http://localhost/API/register.php');
      final response = await http.post(url, body: jsonEncode(request));
      if (response.statusCode != 200) {
        print('failed here');
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody['message']);
      } else if (response.statusCode == 200 && mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DataDisplayPage(
                      registrationData: request,
                    )));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pendaftaran'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              Row(
                children: <Widget>[
                  const Text('Tanggal Lahir: '),
                  Text(_birthdate == DateTime(0000, 00, 00)
                      ? 'Pilih tanggal'
                      : DateFormat('dd-MM-yyyy').format(_birthdate)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _birthdate = selectedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'No Telepon'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'No Telepon tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Alamat Email'),
                validator: (value) {
                  if (value == '') {
                    return 'Alamat Email tidak valid';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              Row(
                children: <Widget>[
                  const Text('Status Menikah: '),
                  DropdownButton<String>(
                    value: _maritalStatus,
                    items: ['Menikah', 'Belum'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _maritalStatus = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text('Jenis Kelamin: '),
                  Radio(
                    value: 'Laki-laki',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Laki-laki'),
                  Radio(
                    value: 'Perempuan',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const Text('Perempuan'),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        handleSubmit();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                      }
                    },
                    child: const Text('View'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataDisplayPage extends StatelessWidget {
  final UserData registrationData;

  const DataDisplayPage({super.key, required this.registrationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pendaftaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nama: ${registrationData.nama}'),
            Text('Alamat: ${registrationData.alamat}'),
            Text(
                'Tanggal Lahir: ${DateFormat('dd-MMyyyy').format(registrationData.tanggalLahir)}'),
            Text('No Telepon: ${registrationData.noTelepon}'),
            Text('Alamat Email: ${registrationData.email}'),
            Text('Status Menikah: ${registrationData.status}'),
            Text('Jenis Kelamin: ${registrationData.jenisKelamin}'),
          ],
        ),
      ),
    );
  }
}
