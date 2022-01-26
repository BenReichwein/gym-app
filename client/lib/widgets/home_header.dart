import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff808080),
            Color(0xff707070),
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
              top: 40.0,
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white60,
              radius: 25,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
              top: 10.0,
            ),
            child: Text(
              "Hi, " + name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20.0,
              top: 10.0,
            ),
            child: const Text(
              "Ready? Get set. Sweat Repeat!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
