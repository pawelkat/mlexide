xquery version "1.0-ml";

module namespace app = "http://marklogic.com/rest-api/resource/collections";

declare namespace roxy = "http://marklogic.com/roxy";
import module namespace admin = "http://marklogic.com/xdmp/admin" 
    at "/MarkLogic/admin.xqy";
import module namespace json = "http://marklogic.com/xdmp/json"
    at "/MarkLogic/json/json.xqy";
(: 
 : returns the list of resources
 :)

declare %private function app:getResources($root){
  let $dbName := tokenize($root, "/")[3]
  let $resources :=
    xdmp:invoke-function(
      function(){cts:uris()},
      <options xmlns="xdmp:eval">
        <database>{xdmp:database($dbName)}</database>
      </options>
    )
  let $json:=
    <json type="object" xmlns="http://marklogic.com/xdmp/json/basic">
      <total type="string">{count($resources)}</total>
      <items type="array">
      {
        for $r in $resources
        return
        <item type="object">
          <name type="string">{$r}</name>
          <permissions type="string">crwxrwxr-x</permissions>
          <owner type="string">admin</owner>
          <group type="string">admin</group>
          <key type="string">{$root||$r}</key>
          <last-modified type="string">09/14/2015 21:35:35</last-modified>
          <writable type="boolean">true</writable>
          <isCollection type="boolean">false</isCollection>
        </item>
      }
      </items>
    </json>
  return
    json:transform-to-json($json)
};

declare %private function app:getDatabasesList(){
  let $config := admin:get-configuration()
  let $items:=
    for $dbId in admin:get-database-ids($config)
    return
      let $item:=json:object()
      let $dbName:=admin:database-get-name($config,$dbId)
      let $fields:=(
        map:put($item, "name", $dbName),
        map:put($item, "permissions", "crwxrwxr-x"),
        map:put($item, "owner", "admin"),
        map:put($item, "group", "admin"),
        map:put($item, "key", "/db/"||$dbName),
        map:put($item, "last-modified", "09/14/2015 21:35:35"),
        map:put($item, "writable", fn:false()),
        map:put($item, "isCollection", fn:true())
        )
      return $item
   let $resp:= json:object()
   let $fields:=(
     map:put($resp, "total", count($items)),
     map:put($resp, "items", json:to-array($items))
   )
   return
     $resp   
};

declare 
%roxy:params("root=xs:string")
function app:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  map:put($context, "output-types", "application/json"),
  let $root := replace(map:get($params, "root"), "//", "/")
  let $result := 
    if($root = ("/db", "/db/")) then app:getDatabasesList() else app:getResources($root)
  return
  (
    xdmp:set-response-code(200, "OK"),
    document { xdmp:to-json-string($result) }
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
