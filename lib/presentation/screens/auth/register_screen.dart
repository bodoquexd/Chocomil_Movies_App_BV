import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:chocomil_movies_app_bv/resources/colors/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles/styles.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/input_widget.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/button_widget.dart';
import 'package:chocomil_movies_app_bv/config/constants/environment.dart';
import 'package:chocomil_movies_app_bv/presentation/widgets/chocolate_painter_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = 'register_screen';

  final Map<String, dynamic>? initialData;

  const RegisterScreen({super.key, this.initialData});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _nombreError;
  String? _apellidoError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isLoading = false;

  void _validarNombre(String value) {
    final regex = RegExp(r'^[A-ZÁÉÍÓÚÑ][a-záéíóúñÁÉÍÓÚÑ\s]+$');
    setState(() {
      if (value.isEmpty) {
        _nombreError = 'El nombre es obligatorio';
      } else if (!regex.hasMatch(value)) {
        _nombreError = 'Debe iniciar con mayúscula y tener solo letras';
      } else {
        _nombreError = null;
      }
    });
  }

  void _validarApellido(String value) {
    final regex = RegExp(r'^[A-ZÁÉÍÓÚÑ][a-záéíóúñÁÉÍÓÚÑ\s]+$');
    setState(() {
      if (value.isEmpty) {
        _apellidoError = 'El apellido es obligatorio';
      } else if (!regex.hasMatch(value)) {
        _apellidoError = 'Debe iniciar con mayúscula y tener solo letras';
      } else {
        _apellidoError = null;
      }
    });
  }

  void _validarEmail(String value) {
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|outlook\.com|live\.com|icloud\.com|yahoo\.com)$',
    );
    setState(() {
      if (value.isEmpty) {
        _emailError = 'El correo es obligatorio';
      } else if (!regex.hasMatch(value)) {
        _emailError = 'Ingresa un correo electrónico válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validarPassword(String value) {
    final regex = RegExp(r'^(?=.*[A-Z]).{8,}$');
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'La contraseña es obligatoria';
      } else if (!regex.hasMatch(value)) {
        _passwordError = 'Mínimo 8 caracteres y una mayúscula';
      } else {
        _passwordError = null;
      }
      if (_confirmPasswordController.text.isNotEmpty) {
        _validarConfirmPassword(_confirmPasswordController.text);
      }
    });
  }

  void _validarConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Confirma tu contraseña';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Las contraseñas no coinciden';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Future<void> _registrarConServidor() async {
    _validarNombre(_nombreController.text);
    _validarApellido(_apellidoController.text);
    _validarEmail(_emailController.text);
    _validarPassword(_passwordController.text);
    _validarConfirmPassword(_confirmPasswordController.text);

    if (_telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa tu número de teléfono'),
        ),
      );
      return;
    }

    if (_nombreError != null ||
        _apellidoError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${Environment.apiUrl}/auth/register');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              //             'bypass-tunnel-reminder': 'true',
            },
            body: jsonEncode({
              'name': _nombreController.text.trim(),
              'last_name': _apellidoController.text.trim(),
              'email': _emailController.text.trim(),
              'phone': _telefonoController.text.trim(),
              'password': _passwordController.text.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Cuenta creada con éxito!')),
          );
          context.push('/login');
        }
      } else {
        if (mounted) {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorData['message'] ?? 'Error al registrar la cuenta',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo conectar con el servidor')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      _nombreController.text = widget.initialData!['name'] ?? '';
      _apellidoController.text = widget.initialData!['last_name'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
      _validarNombre(_nombreController.text);
      _validarApellido(_apellidoController.text);
      _validarEmail(_emailController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  InputWidget(
                    label: 'Nombre',
                    controller: _nombreController,
                    errorText: _nombreError,
                    onChanged: _validarNombre,
                  ),
                  const SizedBox(height: 16),

                  InputWidget(
                    label: 'Apellido',
                    controller: _apellidoController,
                    errorText: _apellidoError,
                    onChanged: _validarApellido,
                  ),
                  const SizedBox(height: 16),

                  InputWidget(
                    label: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    errorText: _emailError,
                    onChanged: _validarEmail,
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
                        borderSide: const BorderSide(
                          color: AppColors.background,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
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
                    errorText: _passwordError,
                    onChanged: _validarPassword,
                  ),
                  const SizedBox(height: 16),

                  InputWidget(
                    label: 'Confirmar contraseña',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    errorText: _confirmPasswordError,
                    onChanged: _validarConfirmPassword,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : ButtonWidget(
                            texto: 'Crear Cuenta',
                            onPressed: _registrarConServidor,
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
          ],
        ),
      ),
    );
  }
}
