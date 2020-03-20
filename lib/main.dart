
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
class AnimalNode {
  String questionText;
  AnimalNode yesNode;
  AnimalNode noNode;
  String name;
  AnimalNode(this.questionText, this.name);
}

class AnimalQuestionBank {
  AnimalNode root;
  AnimalNode currentNode;
  AnimalNode previousNode;
  AnimalQuestionBank(this.root);
  String getCurrentQuestion(AnimalNode currentNode) {
    return currentNode.questionText;
  }

  bool isLastQuestion(AnimalNode currentNode) {
    if(currentNode.yesNode==null && currentNode.noNode==null){
      return true;
    }
    else{
      return false;
    }
  }

  void saveCurrentAnswer(String userResponse) {

  }
  createNewNode(AnimalNode currentNode, AnimalNode previousNode) {
    print("What is the animal?");
    String newAnimal = stdin.readLineSync();
    AnimalNode newAnswerNode = AnimalNode("", " $newAnimal?"); //New Node Created
    print("What question would distinguish between a ${currentNode.name} and a $newAnimal?");
    String newQuestion = stdin.readLineSync();
    AnimalNode newQuestionNode = AnimalNode("$newQuestion", "");
    print("Is the answer 'yes' or 'no' for a $newAnimal?");
    String response = stdin.readLineSync();
    if (response == 'yes') {
      AnimalNode tempNode=currentNode;//save currentNode
      currentNode=newQuestionNode;
      currentNode.yesNode=newAnswerNode;//response yes
      currentNode.noNode=tempNode;
      previousNode.noNode = currentNode;

      print("New yes node added");
    } else if (response == 'no') {
      AnimalNode tempNode=currentNode;//save currentNode
      currentNode=newQuestionNode;
      currentNode.noNode=newAnswerNode;//response yes
      currentNode.yesNode=tempNode;
      previousNode.noNode = currentNode;
      print("New no node added");
    }
  }
  void traverseTree(AnimalNode currentNode, AnimalNode previousNode) {
    while (!isLastQuestion(currentNode)) {
      print(getCurrentQuestion(currentNode));
      String response = stdin.readLineSync();
      if (response == "yes") {
        previousNode = currentNode;
        // save previous node
        currentNode = currentNode.yesNode;
      } else if (response == "no") {
        previousNode = currentNode; // save previous node
        currentNode = currentNode.noNode;
      }
    }
    print(" Is it a ${currentNode.name}");
    String response = stdin.readLineSync();
    if (response == "yes") {
      print("End of Game!");
    } else if (response == "no") {
      print("Oops looks like I need to improve!");
      createNewNode(currentNode, previousNode);
    }
    return;
  }

}
void main(){
AnimalNode root=AnimalNode("Can It Fly?","");
AnimalNode firstYesNode=AnimalNode("","Duck");
AnimalNode firstNoNode=AnimalNode("","Monkey");
root.yesNode=firstYesNode;
root.noNode=firstNoNode;
AnimalQuestionBank myTree=AnimalQuestionBank(root);
myTree.currentNode=root;
myTree.previousNode=null;

while (true) {
  myTree.traverseTree(myTree.currentNode,myTree.previousNode);
}
}
