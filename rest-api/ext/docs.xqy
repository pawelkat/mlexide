xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/docs";

declare namespace roxy = "http://marklogic.com/roxy";

declare namespace xqdoc="http://www.xqdoc.org/1.0";

import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";

declare %private function app:builtin-modules($prefix as xs:string) {
    <items type="array" xmlns="http://marklogic.com/xdmp/json/basic">
      {for $func in doc("/ml-functions.xml")//xqdoc:function 
        where matches($func/xqdoc:name, concat("^(\w+:)?", $prefix))
        order by $func/xqdoc:name
          return app:describe-function($func)
      }
    </items>
};

declare %private function app:generate-help($desc as element(xqdoc:function)) {
    let $help :=
        <div class="function-help">
            <p>{data($desc/xqdoc:comment/xqdoc:description)}</p>
            <dl>

            </dl>
            <dl>

            </dl>
        </div>
    return
        xdmp:quote($help)
};
declare %private function app:create-template($signature as xs:string) {
    string-join(
        let $signature := "substring($source, $starting, $length)"
        for $token in analyze-string($signature, "\$([^\s,\)]+)")/*
        return
            typeswitch($token)
                case element(fn:match) return
                    "$${" || count($token/preceding-sibling::fn:match) + 1 || ":" || $token/fn:group || "}"
                default return
                    $token/node()
    )
};

declare %private function app:describe-function($funct) {
    let $signature := data($funct/xqdoc:signature)
        return
            <item type="object" xmlns="http://marklogic.com/xdmp/json/basic">
                <signature type="string">{$signature}</signature>
                <template type="string">{app:create-template($signature)}</template>
                <help type="string">{app:generate-help($funct)}</help>
                <type type="string">function</type>
                <visibility type="string">public</visibility>
            </item>
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
'[
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
    ]'
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
  let $json:=xdmp:to-json-string(json:transform-to-json(app:builtin-modules($prefix)))
  return
  (
    map:put($context, "output-types", "application/json"),
    xdmp:set-response-code(200, "OK"),
    document { ''||$json }
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
