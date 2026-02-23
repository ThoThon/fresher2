import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatter;
  final String? clearIconAsset;
  final bool showPassword;
  final String? Function(String?)? validator;

  const InputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.inputFormatter,
    this.clearIconAsset,
    this.showPassword = false,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscure = true;
  String _inputText = '';
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.showPassword ? _obscure : false,
            obscuringCharacter: '*',
            cursorColor: const Color(0xFFf24e1e),
            keyboardType: widget.inputFormatter != null
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: widget.inputFormatter,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFf24e1e), width: 2),
              ),
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              errorBorder: InputBorder.none,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFf24e1e), width: 2),
              ),
              suffixIcon: _buildSuffixIcon(),
            ),
            onChanged: (value) => setState(() => _inputText = value),
            validator: (value) {
              final result = widget.validator?.call(value);
              setState(
                () => _errorMessage = result,
              );
              return result;
            },
          ),
          const SizedBox(height: 4),
          if (_errorMessage != null && _errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFf24e1e),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPassword) {
      return IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: SvgPicture.asset(
          _obscure ? 'assets/icons/eyeclose.svg' : 'assets/icons/eyeopen.svg',
          width: 24,
          height: 24,
        ),
      );
    }

    if (_inputText.isNotEmpty && widget.clearIconAsset != null) {
      return IconButton(
        onPressed: () {
          widget.controller.clear();
          setState(() => _inputText = '');
        },
        icon: SvgPicture.asset(
          widget.clearIconAsset!,
          width: 24,
          height: 24,
        ),
      );
    }

    return null;
  }
}
