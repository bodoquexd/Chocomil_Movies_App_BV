import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/chocolate_painter_widget.dart';
import 'package:chocomil_movies_app_bv/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = 'register_screen';

  final Map<String, dynamic>? initialData;

  const RegisterScreen({super.key, this.initialData});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      _nombreController.text = widget.initialData!['name'] ?? '';
      _apellidoController.text = widget.initialData!['last_name'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    if (_telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa tu número de teléfono')),
      );
      return;
    }

    // 3. USO DEL PROVIDER
    final authProvider = context.read<AuthProvider>();
    
    final exito = await authProvider.registrarConServidor(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      email: _emailController.text.trim(),
      telefono: _telefonoController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Cuenta creada con éxito!')),
      );
      context.push('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Error al registrar la cuenta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4. ESCUCHAMOS EL ESTADO DE CARGA
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CABECERA CON CUSTOM PAINTER
            CustomPaint(
              size: const Size(double.infinity, 220),
              painter: ChocolatePainter(color: AppColors.primary),
              child: SizedBox(
                width: double.infinity,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 60),
                    child: Text(
                      'Hola! Regístrate para\nempezar',
                      textAlign: TextAlign.center,
                      style: TextosEstilos.titulo.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // 5. ENVOLVEMOS TODO EN UN FORM
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    InputWidget(
                      label: 'Nombre',
                      controller: _nombreController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El nombre es obligatorio';
                        if (!AuthProvider.nameRegex.hasMatch(value)) {
                          return 'Debe iniciar con mayúscula y tener solo letras';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    InputWidget(
                      label: 'Apellido',
                      controller: _apellidoController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El apellido es obligatorio';
                        if (!AuthProvider.nameRegex.hasMatch(value)) {
                          return 'Debe iniciar con mayúscula y tener solo letras';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    InputWidget(
                      label: 'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'El correo es obligatorio';
                        if (!AuthProvider.emailRegex.hasMatch(value)) {
                          return 'Ingresa un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    IntlPhoneField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      dropdownTextStyle: TextosEstilos.cuerpo.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Número de teléfono',
                        labelStyle: TextosEstilos.cuerpo.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.background),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      initialCountryCode: 'MX',
                      invalidNumberMessage: 'Número de teléfono inválido',
                      style: TextosEstilos.cuerpo,
                      dropdownIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.background,
                      ),
                      onChanged: (phone) {
                        _telefonoController.text = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 16),

                    InputWidget(
                      label: 'Contraseña',
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
                        if (!AuthProvider.passwordRegex.hasMatch(value)) {
                          return 'Mínimo 8 caracteres y una mayúscula';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    InputWidget(
                      label: 'Confirmar contraseña',
                      obscureText: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Confirma tu contraseña';
                        if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                        return null;
                      },
                    ),

                    const SizedBox(height: 40),
                    
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            )
                          : ButtonWidget(
                              texto: 'Crear Cuenta',
                              onPressed: _registrar,
                            ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta? ',
                          style: TextosEstilos.cuerpo.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/login'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Iniciar sesión',
                            style: TextosEstilos.cuerpo.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}