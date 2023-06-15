import 'package:flutter/material.dart';
import 'package:notea_frontend/presentacion/pantallas/login_screen.dart';
import 'package:notea_frontend/presentacion/widgets/email_field.dart';
import 'package:notea_frontend/presentacion/widgets/email_field2.dart';
import 'package:notea_frontend/presentacion/widgets/email_field3.dart';
import 'package:notea_frontend/presentacion/widgets/get_started_button2.dart';
import 'package:notea_frontend/presentacion/widgets/password_field.dart';
import 'package:notea_frontend/presentacion/widgets/password_field2.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController emailController2;
  late TextEditingController emailController3;
  late TextEditingController passwordController;
  late TextEditingController passwordController2;
  final double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;

  @override
  void initState() {
    emailController = TextEditingController();
    emailController2 = TextEditingController();
    emailController3 = TextEditingController();
    passwordController = TextEditingController();
    passwordController2 = TextEditingController();
    super.initState();
  }

    @override
  void dispose() {
    emailController.dispose();
    emailController2.dispose();
    emailController3.dispose();
    passwordController.dispose();
    passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                child: LoginScreen())
            : Padding(
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35),
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
                            EmailField( //username
                                fadeEmail: _elementsOpacity == 0,
                                emailController: emailController),
                            const SizedBox(height: 24),
                            EmailField2( //firstName
                                fadeEmail: _elementsOpacity == 0,
                                emailController: emailController2),
                            const SizedBox(height: 24),
                            EmailField3( //lastName
                                fadeEmail: _elementsOpacity == 0,
                                emailController: emailController3),
                            const SizedBox(height: 24),
                            PasswordField( //password
                                fadePassword: _elementsOpacity == 0,
                                passwordController: passwordController),
                            const SizedBox(height: 24),
                            PasswordField2( //confirm password
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
  }

  Future<void> verificacion() async { //verificacion de campos, contrasena y username
    int code = 0;

    if (emailController.text.isEmpty || emailController2.text.isEmpty || emailController3.text.isEmpty
        || passwordController.text.isEmpty || passwordController2.text.isEmpty) {
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
      // code = await Api.verifyUserId('/users/validate/${emailController.text}');
      if (code == 200) { //si el usuario ya existe
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El usuario ya existe"),
          ),
        );
        return;
      }
      // await createUserDB(emailController.text, emailController2.text,
      //   emailController3.text, passwordController.text);
      // setState(() {
      //   _elementsOpacity = 0;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario creado exitosamente"),
      ),
    );
    }

}
