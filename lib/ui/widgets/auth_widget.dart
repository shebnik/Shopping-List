import 'package:flutter/material.dart';

class AuthWidget extends StatelessWidget {
  final Widget child;

  const AuthWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).size.width > 700;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Row(
            children: [
              if (isLandscape) ...[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.teal,
                        constraints: const BoxConstraints.expand(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.asset('assets/icon/icon.png'),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Shopping List',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
