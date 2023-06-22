// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notea_frontend/dominio/agregados/usuario.dart';
import 'package:notea_frontend/presentacion/widgets/messages_list.dart';

class MessagesScreen extends StatefulWidget {

  final Usuario usuario;
  
  const MessagesScreen({super.key, required this.usuario});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  double loadingBallSize = 1;
  AlignmentGeometry _alignment = Alignment.center;
  bool stopScaleAnimtion = false;
  bool showMessages = true;
  //Notes count
  int notesCount = 0;
  bool showNotesCount = true;

// Callback para actualizar el numero de notas al crear una nueva nota
// Se hace un "Rebuild" de la pantalla (cuando showMessages pasa a true)
  // void callback() {
  //   catchUserNotesCount();
  //   setState(() {
  //     showMessages = false;
  //   }); 
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     setState(() {
  //       showMessages = true;
  //     });
  //   });
  // } //

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _alignment = Alignment.topRight;
        stopScaleAnimtion = true;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // AnimatedAlign(
        //   duration: const Duration(milliseconds: 300),
        //   alignment: _alignment,
        //   child: TweenAnimationBuilder<double>(
        //     duration: const Duration(milliseconds: 500),
        //     tween: Tween(begin: 0, end: loadingBallSize),
        //     onEnd: () {
        //       if (!stopScaleAnimtion) {
        //         setState(() {
        //           if (loadingBallSize == 1) {
        //             loadingBallSize = 1.5;
        //           } else {
        //             loadingBallSize = 1;
        //           }
        //         });
        //       } else {
        //         Future.delayed(const Duration(milliseconds: 300), () {
        //           setState(() {
        //             showMessages = true;
        //           });
        //         });
        //       }
        //     },
        //     builder: (_, value, __) => Transform.scale(
        //       scale: value,
        //       child: Container(
        //           width: 40,
        //           height: 40,
        //           decoration: BoxDecoration(
        //             color: !stopScaleAnimtion
        //                 ? Colors.black.withOpacity(0.8)
        //                 : null,
        //             shape: BoxShape.circle,
        //           ),
        //           child: stopScaleAnimtion
        //               ? TweenAnimationBuilder<double>(
        //                   duration: const Duration(milliseconds: 600),
        //                   tween: Tween(begin: 0, end: 1),
        //                   builder: (_, value, __) => Opacity(
        //                       opacity: value,
        //                       child:
        //                           Image.asset("lib/")))
        //               : null),
        //     ),
        //   ),
        // ),
        if (showMessages) ...[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 1),
                    tween: Tween(begin: 0, end: 1),
                    builder: (_, value, __) => Opacity(
                      opacity: value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, ${widget.usuario.nombre.value} ${widget.usuario.apellido.value}',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.85),
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          if (showNotesCount)
                            Text(
                              'Tienes un total de x notas',
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500),
                            ),
                          if (!showNotesCount)
                            const Text(
                              'Tienes un total de 0 notas',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // if (notesCount == 0)
                  //   MessagesList(
                  //     userId: '1',
                  //     callback2: callback,
                  //   ),
                ],
              ),
            ),
          )
        ],
      ],
    );
  }
}

