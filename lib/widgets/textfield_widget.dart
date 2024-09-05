import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.isPassword = false,
    this.inputFormatters,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.labelText,
    this.onTap,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscured;
  @override
  void initState() {
    setState(() {
      obscured = widget.isPassword;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Gap(6)
        ],
        GestureDetector(
          onTap: widget.onTap,
          child: Row(
            children: [
              Flexible(
                child:
                    FormField<String>(builder: (FormFieldState<String> state) {
                  return TextFormField(
                    controller: widget.controller,
                    validator: widget.validator,
                    inputFormatters: widget.inputFormatters,
                    cursorColor: Colors.grey,
                    enabled: widget.enabled,
                    style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                    onChanged: (v) {
                      state.didChange(v);
                      if (widget.onChanged != null) widget.onChanged!(v);
                    },
                    keyboardType: widget.isPassword
                        ? TextInputType.visiblePassword
                        : widget.keyboardType ?? TextInputType.text,
                    obscureText: obscured,
                    decoration: InputDecoration(
                      prefixIcon: widget.prefixIcon != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Gap(16),
                                widget.prefixIcon!,
                                const Gap(7),
                              ],
                            )
                          : null,
                      suffixIcon: widget.isPassword || widget.suffixIcon != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.isPassword == true)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscured = !obscured;
                                      });
                                    },
                                    child: obscured == true
                                        ? Text(
                                            'Hide',
                                            style: GoogleFonts.lato(
                                                fontSize: 16,
                                                color: Colors.blueGrey),
                                          )
                                        : Text(
                                            'Show',
                                            style: GoogleFonts.lato(
                                                fontSize: 16,
                                                color: Colors.blueGrey),
                                          ),
                                  ),
                                if (widget.suffixIcon != null)
                                  widget.suffixIcon!,
                                const Gap(16)
                              ],
                            )
                          : null,
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.lato(
                          fontSize: 16, color: Colors.blueGrey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: (state.errorText != null &&
                                  state.errorText!.isNotEmpty)
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0,
                          color: (state.errorText != null &&
                                  state.errorText!.isNotEmpty)
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0,
                          color: (state.errorText != null &&
                                  state.errorText!.isNotEmpty)
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0,
                          color: (state.errorText != null &&
                                  state.errorText!.isNotEmpty)
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 0,
                          color: (state.errorText != null &&
                                  state.errorText!.isNotEmpty)
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
