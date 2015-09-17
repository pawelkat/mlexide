xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/execute";

declare namespace roxy = "http://marklogic.com/roxy";

(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") app:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)
declare %private function app:executeQuery($query, $options){
    try{
      let $resp:=xdmp:eval($query,(), $options)
      let $sessionQu:=xdmp:set-session-field("queryResults", $resp)
      return
        <result hits="{count($resp)}" elapsed="0.028"/>
    }catch($err){
      $err
    }
};
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
 :)
declare 
%roxy:params("")
function app:post(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()*
{
  let $qu:=map:get($params, "qu")
  let $dbName:="Documents"
  let $options:=
      <options xmlns="xdmp:eval">
        <database>{xdmp:database($dbName)}</database>
      </options>
  let $result:=app:executeQuery($qu, $options)
  return
  (
    map:put($context, "output-types", "application/xml"),
    xdmp:set-response-code(200, "OK"),
    document { 
      $result
    }
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
