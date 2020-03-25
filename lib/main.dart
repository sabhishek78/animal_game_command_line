import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class AnimalNode {
  Question question;
  AnimalNode yesNode;
  AnimalNode noNode;

  AnimalNode({this.question, this.yesNode, this.noNode});
}

class Question {
  String question;
  QuestionType type;
  List<String> preDeterminedResponses;
  bool isCheckBox;
  bool isImage;
  typeOfController whatController;
  Function callback;

  Question(
      {this.question,
      this.type,
      this.preDeterminedResponses = const [],
      this.isCheckBox = false,
      this.isImage = false,
      this.whatController,
      this.callback}) {
    if (preDeterminedResponses == null) {
      throw ArgumentError();
    }
  }
}

enum QuestionType {
  numeric,
  date,
  multiOption,
  images,
  text,
}

enum typeOfController { percent, dateTime, dollar, text }
enum GameStatus {
  normal,
  addNewAnimalQuestion,
  addNewAnimalName,
  addNewAnimalYesOrNo,
  playAgainQuestion,
  gameOver,
}

class AnimalQuestionBank {
  AnimalNode root;
  AnimalNode temp;
  AnimalNode currentNode;
  AnimalNode previousNode;
  GameStatus currentStatus = GameStatus.normal;

  AnimalQuestionBank({this.root, this.currentNode});
  String previousResponse;
  String newAnimalName;
  String newAnimalQuestion;
  bool _isChatOver = false;

  bool get isChatOver => _isChatOver;

  Question getCurrentQuestion() {
    if (currentStatus == GameStatus.normal) {
      if (isLastQuestion()) {
        return Question(
            question: "Is it A ${currentNode.question.question}?",
            type: QuestionType.multiOption,
            preDeterminedResponses: ["Yes", "No"]);
      } else {
        return Question(
            question: currentNode.question.question,
            type: QuestionType.multiOption,
            preDeterminedResponses: ["Yes", "No"]);
      }
    }
    if (currentStatus == GameStatus.playAgainQuestion) {
      return Question(
          question: "End Of Game. Do you want to play Again?",
          type: QuestionType.multiOption,
          preDeterminedResponses: ["Yes", "No"]);
    }
    if (currentStatus == GameStatus.addNewAnimalName) {
      return Question(question: "Which Animal is it?", type: QuestionType.text);
    }
    if (currentStatus == GameStatus.addNewAnimalQuestion) {
      return Question(
          question:
              "What Question Would distinguish between a ${currentNode.question.question} and $newAnimalName ?",
          type: QuestionType.text);
    }
    if (currentStatus == GameStatus.addNewAnimalYesOrNo) {
      return Question(
          question: "Is the answer Yes or no for  $newAnimalName ?",
          type: QuestionType.multiOption,
          preDeterminedResponses: ["Yes", "No"]);
    }
  }

  bool isLastQuestion() =>
      currentNode.yesNode == null && currentNode.noNode == null;

  void saveCurrentAnswer(String userResponse) {
    if (currentStatus == GameStatus.normal) {
      if (isLastQuestion()) {
        if (userResponse == 'Yes') {
          print("Play again question");
          currentStatus = GameStatus.playAgainQuestion;
          return;
        } else {
          currentStatus = GameStatus.addNewAnimalName;
          return;
        }
      } else {
        //not last node
        if (userResponse == 'Yes') {
          previousResponse=userResponse;
          previousNode = currentNode;
          currentNode = currentNode.yesNode;
          return;
        } else {
          previousResponse=userResponse;
          previousNode = currentNode;
          currentNode = currentNode.noNode;
          return;
        }
      }
    }
    if (currentStatus == GameStatus.playAgainQuestion) {
      if (userResponse == 'Yes') {
        currentStatus = GameStatus.normal;
        currentNode = root;

        return;
      } else {
        currentStatus = GameStatus.gameOver;
        _isChatOver = true;
        return;
      }
    }
    if (currentStatus == GameStatus.addNewAnimalName) {
      newAnimalName = userResponse;
      currentStatus = GameStatus.addNewAnimalQuestion;
      return;
    }
    if (currentStatus == GameStatus.addNewAnimalQuestion) {
      newAnimalQuestion = userResponse;
      currentStatus = GameStatus.addNewAnimalYesOrNo;
      return;
    }
    if (currentStatus == GameStatus.addNewAnimalYesOrNo) {
      if (userResponse == 'Yes') {
        print("reached yes $newAnimalQuestion $newAnimalName");
        temp = currentNode; //save currentNode
        currentNode =
            AnimalNode(question: Question(question: newAnimalQuestion));

        currentNode.yesNode = AnimalNode(
            question: Question(question: newAnimalName)); //response yes
        currentNode.noNode = temp;
        if(previousResponse=='Yes'){
          previousNode.yesNode = currentNode;
        }
        if(previousResponse=='No'){
          previousNode.noNode = currentNode;
        }
        previousNode.yesNode = currentNode;
        currentStatus = GameStatus.normal;
        currentNode=root;
      } else {
         print("reached no $newAnimalQuestion $newAnimalName");
        temp = currentNode;
        currentNode =
            AnimalNode(question: Question(question: newAnimalQuestion));
        currentNode.noNode = AnimalNode(
            question: Question(question: newAnimalName)); //response yes
        currentNode.yesNode = temp;
         if(previousResponse=='Yes'){
           previousNode.yesNode = currentNode;
         }
         if(previousResponse=='No'){
           previousNode.noNode = currentNode;
         }
        previousNode.noNode = currentNode;
        currentStatus = GameStatus.normal;
        currentNode=root;
      }
      return;
    }
  }
}

void main() {
  AnimalNode root = AnimalNode(
      question:
          Question(question: "Can it Fly?", preDeterminedResponses: ['Yes', 'No']));
  AnimalNode yesNode=AnimalNode(
      question:
      Question(question: "Duck", preDeterminedResponses: ['Yes', 'No']));
  AnimalNode noNode=AnimalNode(
      question:
      Question(question: "Tiger", preDeterminedResponses: ['Yes', 'No']));
  root.yesNode=yesNode;
  root.noNode=noNode;
  AnimalQuestionBank bank = AnimalQuestionBank(root: root, currentNode: root);
  while (!bank.isChatOver) {
    print(bank.getCurrentQuestion().question);
    String userResponse = stdin.readLineSync();
    bank.saveCurrentAnswer(userResponse);
  }
}
