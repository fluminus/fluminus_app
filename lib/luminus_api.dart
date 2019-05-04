class API {
  List<Module> modules(Auth auth) {
    List<Module> dummy = new List();
    for(int i=0;i<20;i++) {
      dummy.add(new Module());
    }
    return dummy;
  }
}

class Module {
  String code;
  String id;
  String name;
  bool isTeaching;
  String term;
  String description;

  Module() {
    this.code = "CS2333";
    this.id = "lol";
    this.name = "Computer Insanity";
    this.isTeaching = false;
    this.term = "1820";
    this.description = "dummy yummy hummy funny";
  }

  @override
  String toString() {
    return this.code + " " + this.name;
  }
}

class Auth {
  // necessary stuff for authentication
}