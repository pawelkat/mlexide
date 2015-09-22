xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/outline";

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
  document { "GET called on the ext service extension" }
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
'{
  "modules": [
    {
      "source": "java:org.exist.console.xquery.ConsoleModule",
      "prefix": "console",
      "functions": [
        {
          "name": "console:log",
          "signature": "console:log($items as item()*)",
          "visibility": "public"
        },
        {
          "name": "console:log",
          "signature": "console:log($channel as xs:string, $items as item()*)",
          "visibility": "public"
        },
        {
          "name": "console:send",
          "signature": "console:send($channel as xs:string, $items as item()?)",
          "visibility": "public"
        }
      ]
    },
    {
      "source": "java:org.exist.xquery.modules.mail.MailModule",
      "prefix": "mail",
      "functions": [
        {
          "name": "mail:get-mail-session",
          "signature": "mail:get-mail-session($properties as element()?)",
          "visibility": "public"
        },
        {
          "name": "mail:get-mail-store",
          "signature": "mail:get-mail-store($mail-handle as xs:integer)",
          "visibility": "public"
        }
      ]
    }
  ]
}' 
 :)
declare 
%roxy:params("")
function app:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()*
{
  map:put($context, "output-types", "application/json"),
  xdmp:set-response-code(200, "OK"),
  document { 
  'null' }
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
