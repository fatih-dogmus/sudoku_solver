import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver/state.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: const Text('Çöz'),
                onPressed: () {
                  context.read<BoxState>().solveSudoku();
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: const Text('Hücre sil'),
                onPressed: () {
                  context.read<BoxState>().cellReset();
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: const Text('Temizle'),
                onPressed: () {
                  context.read<BoxState>().clear();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 9,
            children:
                Iterable<int>.generate(context.watch<BoxState>().numbers.length)
                    .toList()
                    .map((int i) {
              return GestureDetector(
                onTap: () {
                  context.read<BoxState>().setClickedIndex(i);
                  List<int> a = context.read<BoxState>().getUniqueNumbers(i);
                  context.read<NumberState>().clearNumbers();
                  for (int i = 0; i < a.length; i++) {
                    context.read<NumberState>().addNumber(a.elementAt(i));
                  }
                  a.clear();
                },
                child: Card(
                    color: context.read<BoxState>().isColored(i)
                        ? Colors.red
                        : i == context.read<BoxState>().clickedIndex
                            ? Colors.redAccent[700]
                            : Colors.white,
                    margin: const EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                          '${context.read<BoxState>().getNumber(i) == 0 ? '' : context.read<BoxState>().getNumber(i)}',
                          style: TextStyle(
                            color: context.read<BoxState>().isColored(i)
                                ? Colors.white
                                : Colors.black,
                          )), //
                    )),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: context.watch<NumberState>().numbers.map((int i) {
              return Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<BoxState>().setNumber(i);
                  },
                  child: Text('$i'),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}