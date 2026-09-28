class FaQ {
  String? question;
  String? answer;

  FaQ({this.question, this.answer});

  factory FaQ.fromJson(Map<String, dynamic> json) => FaQ(
        question: json['question'] as String?,
        answer: json['answer'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };
}
