import 'package:amar_hisab/models/client.dart';
import 'package:amar_hisab/providers/client_provider.dart';
import 'package:amar_hisab/services/google_drive_service.dart';
import 'package:amar_hisab/design_system/design_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  ClientManagementScreenState createState() => ClientManagementScreenState();
}

class ClientManagementScreenState extends State<ClientManagementScreen>
    with SingleTickerProviderStateMixin {
  final GoogleDriveService _googleDriveService = GoogleDriveService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: DesignTokens.durationModerate,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showClientDialog({Client? client}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: client?.name);
    final emailController = TextEditingController(text: client?.email);
    final phoneController = TextEditingController(text: client?.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
          ),
          title: Text(client == null ? 'Add Client' : 'Edit Client'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = nameController.text;
                  final email = emailController.text;
                  final phone = phoneController.text;

                  if (client == null) {
                    Provider.of<ClientProvider>(context, listen: false)
                        .addClient(
                      Client(
                        id: DateTime.now().toString(),
                        name: name,
                        email: email,
                        phone: phone,
                      ),
                    );
                  } else {
                    Provider.of<ClientProvider>(context, listen: false)
                        .updateClient(
                      Client(
                        id: client.id,
                        name: name,
                        email: email,
                        phone: phone,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);
    final clients = clientProvider.clients.where((client) {
      final query = _searchQuery.toLowerCase();
      final name = client.name.toLowerCase();
      final email = client.email.toLowerCase();

      if (_selectedFilter == 0) {
        return name.contains(query) || email.contains(query);
      } else if (_selectedFilter == 1) {
        // Placeholder for active clients
        return name.contains(query) || email.contains(query);
      } else {
        // Placeholder for inactive clients
        return name.contains(query) || email.contains(query);
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () => _googleDriveService.backupData(context),
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _googleDriveService.restoreData(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilter(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildClientListItem(client),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClientDialog(),
        backgroundColor: DesignTokens.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search clients...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CupertinoSlidingSegmentedControl<int>(
        children: const {
          0: Text('All'),
          1: Text('Active'),
          2: Text('Inactive'),
        },
        onValueChanged: (value) {
          setState(() {
            _selectedFilter = value!;
          });
        },
        groupValue: _selectedFilter,
      ),
    );
  }

  Widget _buildClientListItem(Client client) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: DesignTokens.primaryBlue,
          child: Text(
            client.name[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(client.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${client.email} | ${client.phone}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit, color: DesignTokens.primaryBlue),
              onPressed: () => _showClientDialog(client: client),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: DesignTokens.errorRed),
              onPressed: () =>
                  Provider.of<ClientProvider>(context, listen: false)
                      .deleteClient(client.id),
            ),
          ],
        ),
      ),
    );
  }
}