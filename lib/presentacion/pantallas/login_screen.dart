// ignore_for_file: use_build_context_synchronously, sort_child_properties_last
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/infraestructura/bloc/usuario/usuario_bloc.dart';

import 'package:notea_frontend/presentacion/pantallas/register_screen.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/email_field.dart';
import 'package:notea_frontend/presentacion/widgets/oldCode/password_field.dart';
import 'package:notea_frontend/presentacion/pantallas/home_screen.dart';

import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final double _elementsOpacity = 1;
  final _formKey = GlobalKey<FormState>(); //Para validar el formulario
  ButtonState buttonState = ButtonState.idle;
  String userStrJSON = '';

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.text = 'Andres@gmail.com';
    passwordController.text = '542';
    super.initState();
  }

  //Funcion que valida el formulario
  //los await son para mostrar los estados del boton y que se vea mas bonito
  void validacion() async {
    setState(() {
      buttonState = ButtonState.success;
    });
    await Future.delayed(const Duration(seconds: 2), () {});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuarioBloc, UsuarioState>( //siempre va el Bloc y el State
      builder: (context, state) {

        // // #############################################
        // // #############################################
        // // COMENTAR ESTO SI QUIERES PASAR DE UNA AL GOME
        // final usuariofinal = Usuario.crearUsuario('Angel', 'Hernandez','angel@gmail.com', '1234', true, 'dcb52ea6-fd0c-4ce6-9873-ce487cb39787');
        // if(true){
        //   return Scaffold(
        //     resizeToAvoidBottomInset: true,
        //     body: Center(child: MessagesScreen(usuario : usuariofinal)),
        //   );
        // }
        // // #############################################
        // // #############################################

        //se muestra una pantalla diferente dependiendo del estado del bloc
        if (state is UsuarioLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UsuarioFailureState) {
          return const Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(child: Text('Error al iniciar sesión')),
          );
        }
        if (state is UsuarioSuccessState) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Center(child: MessagesScreen(usuario : state.usuario)),
          ); //pagina principal
        }
        if (state is UsuarioInitialState) {
          return Scaffold(
                    resizeToAvoidBottomInset: true,
                    body: SafeArea(
                      bottom: false,
                      child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50.0),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 120.0),
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
                                                "Bienvenido,",
                                                style: TextStyle(
                                                    color: Colors.black, fontSize: 30),
                                              ),
                                              Text(
                                                "Identificate",
                                                style: TextStyle(
                                                    color: Colors.black.withOpacity(0.7),
                                                    fontSize: 30),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                
                                      //Formulario para validación
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            EmailField(fadeEmail: _elementsOpacity == 0,emailController: emailController),
                                            const SizedBox(height: 30),
                                            PasswordField(fadePassword: _elementsOpacity == 0, passwordController: passwordController),
                                            const SizedBox(height: 32),
                                            MaterialButton(
                                              child: Text('Iniciar Sesión', 
                                                        style: TextStyle(fontSize: 16, 
                                                                        color: Colors.grey[200]
                                                      ),),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              color : Theme.of(context).primaryColor,
                                              onPressed: () {
                                                BlocProvider.of<UsuarioBloc>(context).add(
                                                  LoginEvent(
                                                  email: emailController.text,
                                                  password: passwordController.text,
                                                ));
                                              },
                                            ),
                                            const SizedBox(height: 15),
                                              Text(
                                              "¿No tienes una cuenta?",
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.7),
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(height: 7),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const RegisterScreen()),
                                                );
                                              },
                                              child: const Text(
                                                "Registrate",
                                                style: TextStyle(
                                                    color: Color(0xff21579C),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                );
        }
        return const Center(child: CircularProgressIndicator());
      }
      if (state is UsuarioFailureState) {
        return const Scaffold(
          resizeToAvoidBottomInset: true,
          body: Center(child: Text('Error al iniciar sesión')),
        );
      }
      if (state is UsuarioSuccessState) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Center(child: MessagesScreen(usuario: state.usuario)),
        ); //pagina principal
      }
      if (state is UsuarioInitialState) {
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
                              "Bienvenido,",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                            Text(
                              "Identificate",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    //Formulario para validación
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          EmailField(
                              fadeEmail: _elementsOpacity == 0,
                              emailController: emailController),
                          const SizedBox(height: 30),
                          PasswordField(
                              fadePassword: _elementsOpacity == 0,
                              passwordController: passwordController),
                          const SizedBox(height: 32),
                          MaterialButton(
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[200]),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(14),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              BlocProvider.of<UsuarioBloc>(context)
                                  .add(LoginEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ));
                            },
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "¿No tienes una cuenta?",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 15),
                          ),
                          const SizedBox(height: 7),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Registrate",
                              style: TextStyle(
                                  color: Color(0xff21579C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}

//boton de validacion que cambia 
    // ProgressButton.icon(iconedButtons: {
    //   ButtonState.idle: const IconedButton(
    //       text: "Iniciar Sesion",
    //       icon: Icon(Icons.send, color: Colors.white, size: 18),
    //       color: Colors.blueGrey),
    //   ButtonState.loading: IconedButton(
    //       text: "Validando", color: Colors.blueGrey.shade200),
    //   ButtonState.fail: IconedButton(
    //       text: "Fallido",
    //       icon: const Icon(Icons.cancel, color: Colors.white),
    //       color: Colors.red.shade300),
    //   ButtonState.success: IconedButton(
    //       text: "Validado",
    //       icon: const Icon(
    //         Icons.check_circle,
    //         color: Colors.white,
    //       ),
    //       color: Colors.green.shade400)
    // },
    // onPressed: validacion,
    // state: buttonState,
    // maxWidth: 150,
    // height: 40,
    // progressIndicator: const CircularProgressIndicator(
    //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //   strokeWidth: 3,
    // ),
    // )

        //boton de validacion que cambia 
                            // ProgressButton.icon(iconedButtons: {
                            //   ButtonState.idle: const IconedButton(
                            //       text: "Iniciar Sesion",
                            //       icon: Icon(Icons.send, color: Colors.white, size: 18),
                            //       color: Colors.blueGrey),
                            //   ButtonState.loading: IconedButton(
                            //       text: "Validando", color: Colors.blueGrey.shade200),
                            //   ButtonState.fail: IconedButton(
                            //       text: "Fallido",
                            //       icon: const Icon(Icons.cancel, color: Colors.white),
                            //       color: Colors.red.shade300),
                            //   ButtonState.success: IconedButton(
                            //       text: "Validado",
                            //       icon: const Icon(
                            //         Icons.check_circle,
                            //         color: Colors.white,
                            //       ),
                            //       color: Colors.green.shade400)
                            // },
                            // onPressed: validacion,
                            // state: buttonState,
                            // maxWidth: 150,
                            // height: 40,
                            // progressIndicator: const CircularProgressIndicator(
                            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            //   strokeWidth: 3,
                            // ),
                            // )

                                // String username = emailController.text;
    // String password = passwordController.text;
    // if (username.isNotEmpty && password.isNotEmpty) {
    //     setState(() {
    //       buttonState = ButtonState.loading;
    //     });
    //     await Future.delayed(const Duration(milliseconds: 30), () {});
    //   if (true) {
    //   // if (await validateUser(username, password)) {
    //       setState(() {
    //         buttonState = ButtonState.success;
    //       });

    //   // ignore: dead_code
    //   } else {
    //       setState(() {
    //         buttonState = ButtonState.fail;
    //       });
    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text('Nombre de Usuario o Contraseña incorrectos'),
    //     ));
    //     await Future.delayed(const Duration(seconds: 3), () {});
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('Debe llenar todos los campos'),
    //   ));
    // }
    // setState(() {
    //   buttonState = ButtonState.idle;
    // });

