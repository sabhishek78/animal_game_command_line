import 'package:animalgamecommandline/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AnimalNode root=AnimalNode("Is it a Duck?","",null, null);
  AnimalQuestionBank myBank=AnimalQuestionBank(root);

  test('get current Question', (){

    expect(myBank.getCurrentQuestion(root),"Is it a Duck?");

  });
  test('Is last Question', (){

    expect(myBank.isLastQuestion(),true);

  });

}