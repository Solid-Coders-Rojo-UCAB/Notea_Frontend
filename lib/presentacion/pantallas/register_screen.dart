import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/email_field.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/email_field2.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/email_field3.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/get_started_button2.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/password_field.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/password_field2.dart';
import 'HomeScreenWithDrawer.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;
  late TextEditingController passwordController2;
  final double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;

  @override
  void initState() {
    emailController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    passwordController = TextEditingController();
    passwordController2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuarioBloc, UsuarioState>(builder: (context, state) {
      if (state is UsuarioSuccessState) {
        return HomeScreenWithDrawer(usuario: state.usuario);
      }
      // if (state is UsuarioFailureState) {
      //    return const Scaffold(
      //     resizeToAvoidBottomInset: true,
      //     body: Center(child: Text('El usuario ya existe')),
      //   );
      // }
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 1, end: _elementsOpacity),
                    builder: (_, value, __) => Opacity(
                      opacity: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.flutter_dash_sharp,
                                size: 60,
                                color: Color(0xff21579C),
                              ),
                              Text(
                                "Notea",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Registro",
                            style: TextStyle(color: Colors.black, fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        EmailField(
                            //email
                            fadeEmail: _elementsOpacity == 0,
                            emailController: emailController),
                        const SizedBox(height: 24),
                        EmailField2(
                            //firstName
                            fadeEmail: _elementsOpacity == 0,
                            emailController: firstNameController),
                        const SizedBox(height: 24),
                        EmailField3(
                            //lastName
                            fadeEmail: _elementsOpacity == 0,
                            emailController: lastNameController),
                        const SizedBox(height: 24),
                        PasswordField(
                            //password
                            fadePassword: _elementsOpacity == 0,
                            passwordController: passwordController),
                        const SizedBox(height: 24),
                        PasswordField2(
                            //confirm password
                            fadePassword: _elementsOpacity == 0,
                            passwordController: passwordController2),
                        const SizedBox(height: 24),
                        GetStartedButton2(
                          elementsOpacity: _elementsOpacity,
                          onTap: verificacion,
                          onAnimatinoEnd: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            setState(() {
                              loadingBallAppear = true;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> verificacion() async {
    //verificacion de campos, contrasena y username
    int code = 0;

    if (emailController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordController2.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe llenar todos los campos"),
        ),
      );
      return;
    }
    if (passwordController.text != passwordController2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Las contraseñas no coinciden"),
        ),
      );
      return;
    }
    if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La contraseña debe tener al menos 8 caracteres"),
        ),
      );
      return;
    }

    final grupoBloc = BlocProvider.of<UsuarioBloc>(context);
    grupoBloc.add(RegisterEvent(
      email: emailController.text,
      password: passwordController.text,
      nombre: firstNameController.text,
      apellido: lastNameController.text,
      suscripcion: false,
    ));
    await Future.delayed(const Duration(milliseconds: 500));
    if (grupoBloc.state.existeUsuario) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario creado exitosamente"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El usuario ya existe"),
        ),
      );
    }
  }
}
