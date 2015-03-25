- tests
- prefix of library
- add factory for JsList
- VarArgs
- Enum ?
- generate code for static members (see Marker.MAX_ZINDEX)
- generate state in .created from initialized variables?
- test on Google Maps
- optim: `[toJs(a), toJs(b)]` instead of `[a, b].map(toJs).toList()`

BAD IDEA
- JsGlobal: not for the moment use a private template and bind top level to it.
- use Expando<JsObject> instead of JsInterface._jsObject ? => NO because 
inheritance will hurt super.created() vs. super.WAT ??? 
- @Export  : see dev_compiler