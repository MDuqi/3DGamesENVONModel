PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?start ?goal ?pathExists ?roomsVisited
WHERE {
  # Ponto inicial
  ge:Player1 ge:hasLocation ?start .
  # Objetivo
  ?goal a ge:Place ;
        ge:isGoal "true"^^xsd:boolean .
  
  # Procurar uma porta que conecte o ponto inicial
  ?door a ge:Door ;
        ge:connects ?start .
  # Verificar se a mesma porta ou outra conecta ao objetivo
  ?door ge:connects ?goal .
  
  # Coletar salas percorridas (neste caso, start e goal)
  BIND(CONCAT(STR(?start), " -> ", STR(?goal)) AS ?roomsVisitedPath)
  
  # Verificar dimensões da porta
  ?door ge:hasBoundingBox ?bbox .
  ?bbox ge:hasMinimumPoint ?minPoint ;
        ge:hasMaximumPoint ?maxPoint .
  ?minPoint ge:z ?minZ ;
            ge:y ?minY .
  ?maxPoint ge:z ?maxZ ;
            ge:y ?maxY .
  BIND((?maxZ - ?minZ) AS ?doorHeight)
  BIND((?maxY - ?minY) AS ?doorWidth)
  FILTER(?doorHeight >= 2.0 && ?doorWidth >= 1.0)
  
  # Determinar se o caminho existe e é viável
  BIND(BOUND(?door) && ?doorHeight >= 2.0 && ?doorWidth >= 1.0 AS ?pathExists)
  BIND(COALESCE(?roomsVisitedPath, "No path") AS ?roomsVisited)
}