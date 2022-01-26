import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Exercise extends StatefulWidget {
  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  @override
  Widget build(BuildContext context) {
    List data = [
      {
        'title': 'Arm Exercise',
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
        'date': 'Dec 20th, 2021'
      },
      {
        'title': 'Arm Exercise',
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
        'date': 'Dec 20th, 2021'
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise',
        ),
        backgroundColor: const Color(0xff707070),
        elevation: 7,
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            var image = data[index]['image'];
            var title = data[index]['title'];
            var date = data[index]['date'];
            return Container(
              margin: const EdgeInsets.all(8.0),
              height: 140,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Align(
                  alignment: const Alignment(-0.9, 1.6),
                  child: Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                Align(
                  alignment: const Alignment(-0.9, 1.7),
                  child: Text(date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      )),
                ),
              ]),
            );
          }),
    );
  }
}
