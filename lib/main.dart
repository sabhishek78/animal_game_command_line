
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
class AnimalNode {
  String questionText;
  AnimalNode yesNode;
  AnimalNode noNode;
  String name;
  AnimalNode(this.questionText, this.name,this.yesNode,this.noNode);
}

class AnimalQuestionBank {
  AnimalNode root;
  AnimalNode currentNode;
  AnimalNode previousNode;
  AnimalQuestionBank(this.root);
  String getCurrentQuestion(AnimalNode currentNode) {

  }

  bool isLastQuestion() {

  }

  void saveCurrentAnswer(String userResponse) {

  }

}
void main(){
AnimalNode root=AnimalNode("Is it a Duck?","",null, null);
AnimalQuestionBank myBank=AnimalQuestionBank(root);
}