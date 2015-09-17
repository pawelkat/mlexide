xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/docs";

declare namespace roxy = "http://marklogic.com/roxy";

(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") app:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)

(:
 :)
declare 
%roxy:params("")
function app:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "application/xml"),
  xdmp:set-response-code(200, "OK"),
  document {  "GET called"  }
};

(:
 :)
declare 
%roxy:params("")
function app:put(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()?
{
  map:put($context, "output-types", "application/xml"),
  xdmp:set-response-code(200, "OK"),
  document { "PUT called on the ext service extension" }
};

(:
 :)
declare 
%roxy:params("prefix=xs:string")
function app:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()*
{
  let $prefix := map:get($params, "prefix")
  return
  (
    map:put($context, "output-types", "application/json"),
    xdmp:set-response-code(200, "OK"),
    document { '[
      {
        "signature": "datetime:format-date($date as xs:date, $simple-date-format as xs:string)",
        "template": "substring($${1:source}, $${2:starting}, $${3:length})",
        "help": "<div class=\"function-help\">\n    <p>Returns a xs:string of the xs:date formatted according to the SimpleDateFormat format.</p>\n    <dl>\n        <dt>$date as xs:date</dt>\n        <dd>The date to to be formatted.</dd>\n        <dt>$simple-date-format as xs:string</dt>\n        <dd>The format string according to the Java java.text.SimpleDateFormat class</dd>\n    </dl>\n    <dl>\n        <dt>Returns: xs:string</dt>\n        <dd>the formatted date string</dd>\n    </dl>\n</div>",
        "type": "function",
        "visibility": "public"
      },
      {
        "signature": "datetime:format-dateTime($date-time as xs:dateTime, $simple-date-format as xs:string)",
        "template": "substring($${1:source}, $${2:starting}, $${3:length})",
        "help": "<div class=\"function-help\">\n    <p>Returns a xs:string of the xs:dateTime according to the SimpleDateFormat format.</p>\n    <dl>\n        <dt>$date-time as xs:dateTime</dt>\n        <dd>The dateTime to to be formatted.</dd>\n        <dt>$simple-date-format as xs:string</dt>\n        <dd>The format string according to the Java java.text.SimpleDateFormat class</dd>\n    </dl>\n    <dl>\n        <dt>Returns: xs:string</dt>\n        <dd>the formatted dateTime string</dd>\n    </dl>\n</div>",
        "type": "function",
        "visibility": "public"
      }
    ]' }
  )
};

(:
 :)
declare 
%roxy:params("")
function app:delete(
    $context as map:map,
    $params  as map:map
) as document-node()?
{
  map:put($context, "output-types", "application/xml"),
  xdmp:set-response-code(200, "OK"),
  document { "DELETE called on the ext service extension" }
};
