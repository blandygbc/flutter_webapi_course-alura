import 'dart:developer' as devtools;
import 'dart:math';

asyncStudy() {}

void execucaoNormal() {
  devtools.log("\nExecução Normal");
  devtools.log("01");
  devtools.log("02");
  devtools.log("03");
  devtools.log("04");
  devtools.log("05");
}

void assincronismoBasico() {
  devtools.log("\nAssincronismo Básico");
  devtools.log("01");
  devtools.log("02");
  Future.delayed(const Duration(seconds: 2), () {
    devtools.log("03");
  });
  devtools.log("04");
  devtools.log("05");
}

void usandoFuncoesAssincronas() {
  devtools.log("\nUsando funções assíncronas");
  devtools.log("A");
  devtools.log("B");
  //print(getRandomInt(3)); // Instance of Future<int>
  getRandomInt(3).then((value) {
    devtools.log("O número aleatório é $value.");
    // E se eu quiser que as coisas só aconteçam depois?
  });
  devtools.log("C");
  devtools.log("D");
}

void esperandoFuncoesAssincronas() async {
  devtools.log("A");
  devtools.log("B");
  int number = await getRandomInt(4);
  devtools.log("O outro número aleatório é $number.");
  devtools.log("C");
  devtools.log("D");
}

Future<int> getRandomInt(int time) async {
  await Future.delayed(Duration(seconds: time));

  Random rng = Random();

  return rng.nextInt(10);
}
