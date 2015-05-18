- handle union type
- implements all unimplemented methods from inheritance(extends/implements/with)
- generate code for top level members
- named parameters to anonymous object
- generate state in .created from initialized variables?
- prefix of library



BAD IDEA

- VarArgs ? see http://dartbug.com/16253
- JsGlobal: not for the moment use a private template and bind top level to it.
- use Expando<JsObject> instead of JsInterface._jsObject ? => NO because 
inheritance will hurt super.created() vs. super.WAT ??? 
- @Export  : see dev_compiler