import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/admin_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'admin_login_model.dart';
export 'admin_login_model.dart';

class AdminLoginWidget extends StatefulWidget {
  const AdminLoginWidget({super.key});

  static String routeName = 'AdminLogin';
  static String routePath = '/admin';

  @override
  State<AdminLoginWidget> createState() => _AdminLoginWidgetState();
}

class _AdminLoginWidgetState extends State<AdminLoginWidget> {
  late AdminLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminLoginModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    final email = _model.emailTextController?.text.trim() ?? '';
    final password = _model.passwordTextController?.text ?? '';

    debugPrint('Admin login attempt - Email: $email');

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _model.errorMessage = 'Please enter both email and password';
        _model.isLoading = false;
      });
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    final isValid = AdminCredentials.validateCredentials(email, password);
    debugPrint('Admin credentials valid: $isValid');

    if (isValid) {
      debugPrint('Navigating to AdminDashboard');
      if (mounted) {
        context.go('/admin-dashboard');
      }
    } else {
      setState(() {
        _model.errorMessage = 'Invalid admin credentials';
        _model.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 40,
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Admin Portal',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to access the dashboard',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Onest',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (_model.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: FlutterFlowTheme.of(context).error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _model.errorMessage!,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Onest',
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        'Email',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.emailTextController,
                        focusNode: _model.emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'admin@vuka265.com',
                          hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0,
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily: 'Onest',
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Password',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.passwordTextController,
                        focusNode: _model.passwordFocusNode,
                        obscureText: !_model.passwordVisibility,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: FlutterFlowTheme.of(context).labelLarge.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0,
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(() {
                              _model.passwordVisibility = !_model.passwordVisibility;
                            }),
                            child: Icon(
                              _model.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                          fontFamily: 'Onest',
                          letterSpacing: 0,
                        ),
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: 32),
                      FFButtonWidget(
                        onPressed: _model.isLoading ? null : _handleLogin,
                        text: _model.isLoading ? 'Signing in...' : 'Sign In',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Onest',
                            color: Colors.white,
                            letterSpacing: 0,
                          ),
                          elevation: 0,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => context.go('/'),
                        child: Text(
                          'Back to App',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Onest',
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
