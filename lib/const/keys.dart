  import 'package:encrypt/encrypt.dart' as encrypt;
  final plainText = 'password';
  final key = encrypt.Key.fromUtf8('my 32 length key................');
  final iv = encrypt.IV.fromLength(16);
   final encrypter = encrypt.Encrypter(encrypt.AES(key));