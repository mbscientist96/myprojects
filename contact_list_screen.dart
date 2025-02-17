import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Contact {
  final String nome;
  final String telefone;

  Contact({required this.nome, required this.telefone});

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'telefone': telefone};
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      nome: map['nome'],
      telefone: map['telefone'],
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> _contacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? contactsData = prefs.getString('contacts');
    if (contactsData != null) {
      final List decodedContacts = jsonDecode(contactsData);
      setState(() {
        _contacts.addAll(
          decodedContacts.map((c) => Contact.fromMap(c)).toList(),
        );
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String contactsData = jsonEncode(_contacts.map((c) => c.toMap()).toList());
    await prefs.setString('contacts', contactsData);
  }

  void _addContact() {
    final String nome = _nameController.text.trim();
    final String telefone = _phoneController.text.trim();

    if (nome.isNotEmpty && telefone.isNotEmpty) {
      setState(() {
        _contacts.add(Contact(nome: nome, telefone: telefone));
      });
      _saveContacts();
      _nameController.clear();
      _phoneController.clear();
      Navigator.of(context).pop();
    }
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts();
  }

  List<Contact> get _filteredContacts {
    return _contacts.where((contact) {
      return contact.nome.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Adicionar Telefone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Número de telefone'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _addContact,
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Contatos'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar contatos',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? Center(child: Text('Sem contatos adicionados'))
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(contact.nome),
                          subtitle: Text(contact.telefone),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteContact(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactDialog,
        label: Text('Adicionar Telefone'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ContactListScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[100],
    ),
  ));
}
