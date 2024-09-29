import 'dart:math';

String generarIdRandom(int longitud) {
  const caracteres =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random random = Random();
  String idRandom = '';

  for (int i = 0; i < longitud; i++) {
    int indiceAleatorio = random.nextInt(caracteres.length);
    idRandom += caracteres[indiceAleatorio];
  }

  return idRandom;
}
