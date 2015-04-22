- Enum ? generate codec @jsEnum(mapping: const {Enum.V1:'v1name'})
- handle Map<String, ?> (see FusionTablesMouseEvent.row)
- generate code for static members (see Marker.MAX_ZINDEX)
- generate code for top level members
- extract codecs to have only one instance by type
- named parameters to anonymous object
- generate state in .created from initialized variables?
- test on Google Maps
- prefix of library



BAD IDEA
- VarArgs ? see http://dartbug.com/16253
- JsGlobal: not for the moment use a private template and bind top level to it.
- use Expando<JsObject> instead of JsInterface._jsObject ? => NO because 
inheritance will hurt super.created() vs. super.WAT ??? 
- @Export  : see dev_compiler