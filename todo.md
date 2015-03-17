- tests
- prefix of library
- add factory for JsList
- remove initializeJavaScript
- VarArgs
- Enum ?
- generate state in .created from initialized variables.
- test on Google Maps
- rename .created with .proxify
- optim: `[toJs(a), toJs(b)]` instead of `[a, b].map(toJs).toList()`

BAD IDEA
- JsGlobal: not for the moment use a private template and bind top level to it.
- use Expando<JsObject> instead of JsInterface._jsObject ? => NO because 
inheritance will hurt super.created() vs. super.WAT ??? 
- remove @Proxy ? implements JsInterface is enough  => NO because consistancy
with top-level variables
- @Export  : see dev_compiler