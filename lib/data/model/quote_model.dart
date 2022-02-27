class Quote{

  String? quote;


  Quote.fromjson(Map<String , dynamic > json){

    quote = json['quote'];
  }
}