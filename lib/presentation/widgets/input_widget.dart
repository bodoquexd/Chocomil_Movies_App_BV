import 'package:flutter/material.dart';
import 'package:chocomil_movies_app_bv/resources/colors.dart';
import 'package:chocomil_movies_app_bv/resources/styles.dart';

class InputWidget extends StatefulWidget {
  final String label;
  final bool obscureText;

  const InputWidget({
    super.key,
    required this.label,
    this.obscureText = false,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscured,
      style: TextosEstilos.cuerpo, 
      
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextosEstilos.cuerpo.copyWith(
          color: AppColors.textPrimary,
        ),

        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.background),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}