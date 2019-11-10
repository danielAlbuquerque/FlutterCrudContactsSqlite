
import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactScreen extends StatefulWidget {

  final Contact contact;

  ContactScreen({this.contact});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  Contact _editedContact;

  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if(widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _phoneController.text = _editedContact.phone;
      _emailController.text = _editedContact.email;
    }
  }

  Future<bool> _requestPop() {
    if(_userEdited) {
      showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar alteracoes?"),
            content: Text("Se sair as alteracoes seram perdidas"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(_editedContact.name ?? "Novo contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  File image = await ImagePicker.pickImage(source: ImageSource.camera);
                  if(image == null) return;

                  setState(() {
                    _editedContact.img = image.path;
                  });
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/user.png"),
                          fit: BoxFit.cover
                      ),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Nome"
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email"
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: "Phone"
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
