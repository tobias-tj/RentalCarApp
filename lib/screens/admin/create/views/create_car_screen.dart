import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car_app/components/create_id_random.dart';
import 'package:rental_car_app/screens/admin/create/blocs/create_car/create_car_bloc.dart';

class CreateCarScreen extends StatefulWidget {
  const CreateCarScreen({super.key});

  @override
  State<CreateCarScreen> createState() => _CreateCarScreenState();
}

class _CreateCarScreenState extends State<CreateCarScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final _picker = ImagePicker();

  // Controladores de texto para el formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cvController = TextEditingController();
  final TextEditingController _transmissionController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _priceDayController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  // Método para seleccionar imagen
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final carId = generarIdRandom(20);

  // Método para enviar el formulario
  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      BlocProvider.of<CreateCarBloc>(context).add(
        CreateCarRequired(
            _selectedImage!,
            carId,
            _nameController.text,
            _cvController.text,
            _transmissionController.text,
            _peopleController.text,
            _priceDayController.text,
            _engineController.text,
            _typeController.text),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cvController.dispose();
    _transmissionController.dispose();
    _peopleController.dispose();
    _priceDayController.dispose();
    _engineController.dispose();
    _typeController.dispose();
    _selectedImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<CreateCarBloc, CreateCarState>(
        listener: (context, state) {
          if (state is CreateCarSuccess) {
            // Mostrar el SnackBar de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡El vehículo ha sido creado con éxito!'),
                duration: Duration(seconds: 2),
              ),
            );
            // Limpiar los TextControllers y la imagen
            setState(() {
              _nameController.clear();
              _cvController.clear();
              _transmissionController.clear();
              _peopleController.clear();
              _priceDayController.clear();
              _engineController.clear();
              _typeController.clear();
              _selectedImage = null;
            });
          } else if (state is CreateCarFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ocurrió un error al crear el vehículo.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.onBackground,
            title: Text('Crear Vehículo'),
          ),
          backgroundColor: theme.colorScheme.background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage == null
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.black,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Nombre del Vehículo',
                    icon: Icons.drive_eta,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cvController,
                    hintText: 'CV',
                    icon: Icons.speed,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceDayController,
                    hintText: 'Precio por día',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _transmissionController,
                    hintText: 'Transmisión',
                    icon: Icons.settings,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _peopleController,
                    hintText: 'Cantidad de personas',
                    icon: Icons.people,
                    keyboardType: TextInputType.number,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _engineController,
                    hintText: 'Motor',
                    icon: Icons.engineering,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _typeController,
                    hintText: 'Tipo',
                    icon: Icons.category,
                    theme: theme,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: theme.colorScheme.onBackground,
                    ),
                    child: Text(
                      'Crear Vehículo',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: theme.colorScheme.onBackground),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
    );
  }
}
