PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?playerLoc ?shieldLoc ?px ?py ?sx ?sy ?canCollect
WHERE {
  # Localização de Player1
  ge:Player1 ge:hasLocation ?playerLoc .
  # Localização de Shield1
  ge:Shield1 ge:hasLocation ?shieldLoc .
  
  # Verificar se estão na mesma localização
  FILTER(?playerLoc = ?shieldLoc)
  
  # Origens das hitboxes
  ge:Player1 ge:hasOrigin ?playerOrigin .
  ?playerOrigin ge:hasPosition ?Player1_Vector3D.
  ge:Shield1 ge:hasStandardForm ?shieldHitbox .
  ?shieldHitbox ge:hasOrigin ?shieldOrigin .
  
  # Coordenadas
  ?Player1_Vector3D ge:x ?px ; ge:y ?py .
  ?shieldOrigin ge:x ?sx ; ge:y ?sy .
  
  # Verificar proximidade (aproximação para coleta, diâmetro de Player1 = 3.0)
  BIND(ABS(?px - ?sx) <= 3.0 && ABS(?py - ?sy) <= 3.0 AS ?canCollect)
}