xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/compile";

declare namespace roxy = "http://marklogic.com/roxy";

(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") app:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)

(:declare %private function app:performCheck($query, $options){
  let $staticCheck:=
    try{
      xdmp:eval(xs:string($query,(), $options))
    }catch($exception){
        $exception
    }
  return
    if ($staticCheck="") then
      (<json/>)
    else
      ($staticCheck)
};:)

declare %private function app:checkQuery($query, $options){
    try{
      let $check:=xdmp:eval($query,(), $options)
      return
        '{"result":"pass"}'
    }catch($err){
      let $frame1:=$err/error:stack/error:frame[1]
      let $code:=replace($err/error:format-string/text(), '"', "'")
      let $line:=if ($frame1/error:line) then ($frame1/error:line/text()) else ("1")
      let $column:=if ($frame1/error:column) then ($frame1/error:column/text()) else ("1")
      let $text:=$err/error:data/error:datum/text()
      return
      '{
      "result": "fail",
      "error": {
        "code": "'||$code||'",
        "line": "'||$line||'",
        "column": "'||$column||'",
        "#text": "'||$code||'"
        }
      }'
    }
};

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
'{
      "result": "fail",
      "error": {
        "code": "(http://www.w3.org/2005/xqt-errors/#XPST0003):It is a static error if an expression is not a valid instance of the grammar defined in A.1 EBNF.",
        "line": "2",
        "column": "9",
        "#text": "Syntax error within user defined function notification:send-email: unexpected token: mail"
      }
    }' 
 :)
declare 
%roxy:params("")
function app:put(
    $context as map:map,
    $params  as map:map,
    $input   as document-node()*
) as document-node()?
{
  let $path := replace(map:get($params, "base"), "//", "/")
  let $dbName := tokenize($path, "/")[3]
  (:let $dbName:="Documents":)
  let $options:=
      <options xmlns="xdmp:eval">
        <database>{xdmp:database($dbName)}</database>
        <static-check>true</static-check>
      </options>
  let $result:=app:checkQuery(xdmp:quote($input), $options)
  return
  (
    map:put($context, "output-types", "application/json"),
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
