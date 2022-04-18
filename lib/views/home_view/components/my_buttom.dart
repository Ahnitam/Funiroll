import 'package:flutter/material.dart';

class MyButtom extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final double fontSize;
  final Color color;
  final VoidCallback? onPressed;
  late final BorderRadius borderRadius;

  MyButtom({Key? key, required this.label, required this.onPressed, this.fontSize = 10, required this.width, required this.height, this.color = const Color.fromARGB(169, 27, 94, 31), BorderRadius? borderRadius}) : super(key: key) {
    this.borderRadius = borderRadius ?? BorderRadius.circular(20);
  }

  // final ShapeBorder shape;

  // const MyButtom({Key? key, required this.label, required this.onPressed, this.fontSize = 10, this.width = 0, this.height = 0, this.color = const Color.fromARGB(169, 27, 94, 31), this.shape = const StadiumBorder()}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: color,
        height: height,
        width: width,
        child: RawMaterialButton(
          onPressed: onPressed,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: width,
  //     height: height,
  //     margin: margin,
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(25.0),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(25),
  //       child: MaterialButton(
  //         padding: const EdgeInsets.only(left: 2, right: 2),
  //         textColor: Colors.white,
  //         child: Text(
  //           label,
  //           maxLines: 1,
  //           style: const TextStyle(
  //             fontSize: 10,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         onPressed: onPressed,
  //       ),
  //     ),
  //   );
  // }
}
