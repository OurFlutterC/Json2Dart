import requests
import os
import time


def Json2Dart(inputUser, className):
    data = ""
    parameters = ""
    fromVar = ""
    toVar = ""
    dataType = {"<class 'str'>": "String", "<class 'int'>": "int", "<class 'list'>": "List",
                "<class 'float'>": "double", "<class 'dict'>": "Map", "<class 'bool'>": "bool", "<class 'NoneType'>": "var"}
    for i in inputUser:
        for u in i.keys():
            t = type(i[u])
            data += f""" {dataType[str(t)]} {u};\n"""
            parameters += f"""  this.{u},\n"""
            fromVar += f"  {u} = json['{u}'];\n"
            toVar += f"  data['{u}'] = this.{u};\n"
        break
    data+="List multi = [];"
    fromVar+="  return super.fromJson(json);\n"
    multi = """\nvoid setMulti(List d) {
    List r = d.map((e) {
      %s m = %s();
      m.fromJson(e);
      return m;
    }).toList();
    multi = r;
  }\n"""%(className,className)
    toJson = " Map<String, dynamic> toJson() {\n final Map<String, dynamic> data = new Map<String, dynamic>();"
    fromJson = " fromJson(Map<String, dynamic> json) {"
    class_ = "class %s extends McModel{\n" % className
    constractor = " %s({" % className
    model = class_ + data + "\n"+constractor+"\n"+parameters+" });\n"+"\n"+fromJson + \
        "\n"+fromVar+" }"+"\n"+toJson+"\n"+toVar+"\n"+"  return data;"+"\n }"+multi+"\n"+"}"
    open(f"{className}Model.dart", "w+").write(model)
    path = os.path.realpath(f"{className}Model.dart")
    print(model)


def getData(link):
    req = requests.get(link)
    return eval('['+str(req.json()[0]) + ']')


inputUser = input(f" [+] Your Json data or path file or link Api: ")
className = input(f" [+] Your dart class name (default name MyModel): ")
if len(className.strip()) == 0:
    className = "MyModel"
try:
    if inputUser[:4] == "http":
        inputUser = getData(inputUser)
    else:
        if ".json" in inputUser:
            inputUser = open(inputUser, "r").read()
        if "dict" in str(type(eval(inputUser))):
            inputUser = eval("["+inputUser+"]")
        elif "list" in str(type(eval(inputUser))):
            inputUser = eval(inputUser)

    Json2Dart(inputUser, className.strip())
except NameError or SyntaxError:
    print(" [-] Json format incorrect")
except FileNotFoundError:
    print(f" [-] No such file or directory: {inputUser}")


time.sleep(5)
