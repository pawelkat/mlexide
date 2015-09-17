xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/load";

declare namespace roxy = "http://marklogic.com/roxy";

(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") app:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)

declare %private function app:getResource($uri, $options){
    xdmp:invoke-function(
      function(){document($uri)},
      $options
    )
};

declare %private function app:getContentType($uri, $options){
    xdmp:invoke-function(
      function(){xdmp:uri-content-type($uri)},
      $options
    )
};

declare 
%roxy:params("path=xs:string")
function app:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{  
  let $path := replace(map:get($params, "path"), "//", "/")
  let $dbName := tokenize($path, "/")[3]
  let $uri:=fn:substring-after($path, $dbName)
  let $options:=
      <options xmlns="xdmp:eval">
        <database>{xdmp:database($dbName)}</database>
      </options>
  return
  (
    map:put($context, "output-types", app:getContentType($uri, $options)),
    xdmp:set-response-code(200, "OK"),
    document { app:getResource($uri, $options) }
  )
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
%roxy:params("")
function app:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()*
{
  map:put($context, "output-types", "application/xml"),
  xdmp:set-response-code(200, "OK"),
  document { "POST called on the ext service extension" }
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
