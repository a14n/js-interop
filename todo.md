- @Name
- VarArgs
- test on Google Maps
- optim: `[toJs(a), toJs(b)]` instead of `[a, b].map(toJs).toList()`

BAD IDEA
- use Expando<JsObject> instead of JsInterface._jsObject ? => NO because 
inheritance will hurt super.created() vs. super.WAT ??? 
- remove @Proxy ? implements JsInterface is enough  => NO because consistancy
with top-level variables
- @Export  : see dev_compiler