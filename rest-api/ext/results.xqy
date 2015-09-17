xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/results";

declare namespace roxy = "http://marklogic.com/roxy";

import module namespace pretty = "http://exist-db.org/eXide/pretty"
    at "/modules/pretty-print.xqy";
(: 
 : To add parameters to the functions, specify them in the params annotations. 
 : Example
 :   declare %roxy:params("uri=xs:string", "priority=xs:int") app:get(...)
 : This means that the get function will take two parameters, a string and an int.
 :)
(:~ Retrieve a single query result. :)
declare %private function app:retrieve($num as xs:int, $cached) as element() {
    let $node := $cached[$num]
    let $item := 
      if ($node instance of node()) then
        (:util:expand($node, 'indent=yes'):)
        $node
      else
        $node
    let $documentURI :=if ($node instance of node()) then base-uri($node) else ()
    return
        <div class="{if ($num mod 2 eq 0) then 'even' else 'uneven'}">
            {
                if (string-length($documentURI) > 0) then
                    <div class="pos">
                    {
                        if (string-length($documentURI) > 0) then
                            <a href="{$documentURI}" data-path="{$documentURI}"
                                title="Click to load source document">{$num}</a>
                        else
                            ()
                    }
                    </div>
                else
                    ()
            }
            <div class="item">
              { pretty:pretty-print($item, ()) }
            </div>
        </div>
};
(:
 :)
declare 
%roxy:params("id=xs:int")
function app:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  let $id:=xs:int(map:get($params, "id"))
  let $cached:=xdmp:get-session-field("queryResults")
  return(
    map:put($context, "output-types", "application/xml"),
    xdmp:set-response-code(200, "OK"),
    document { app:retrieve($id, $cached) }
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
