PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?start ?goal ?pathExists ?roomsVisited
WHERE {
  # Ponto inicial
  ge:Player1 ge:hasLocation ?start .
  # Objetivo
  ?goal a ge:Place ;
        ge:isGoal "true"^^xsd:boolean .
  
  # Trajeto completo: Room1 -> Door1 -> Room2 -> Door2 -> Room3
  OPTIONAL {
    # Primeira conexão: Room1 -> Door1 -> Room2
    ?door1 a ge:Door ;
           ge:connects ?start ;
           ge:connects ?intermediate1 .
    # Segunda conexão: Room2 -> Door2 -> Room3
    ?door2 a ge:Door ;
           ge:connects ?intermediate1 ;
           ge:connects ?goal .
    
    # Coletar salas percorridas
    BIND(CONCAT(STR(?start), " -> ", STR(?intermediate1), " -> ", STR(?goal)) AS ?roomsVisitedPath)
    
    # Verificar dimensões de Door1
    ?door1 ge:hasBoundingBox ?bbox1 .
    ?bbox1 ge:hasMinimumPoint ?minPoint1 ;
           ge:hasMaximumPoint ?maxPoint1 .
    ?minPoint1 ge:z ?minZ1 ;
               ge:y ?minY1 .
    ?maxPoint1 ge:z ?maxZ1 ;
               ge:y ?maxY1 .
    BIND((?maxZ1 - ?minZ1) AS ?door1Height)
    BIND((?maxY1 - ?minY1) AS ?door1Width)
    
    # Verificar dimensões de Door2 (ajustado para largura no eixo X)
    ?door2 ge:hasBoundingBox ?bbox2 .
    ?bbox2 ge:hasMinimumPoint ?minPoint2 ;
           ge:hasMaximumPoint ?maxPoint2 .
    ?minPoint2 ge:z ?minZ2 ;
               ge:x ?minX2 .
    ?maxPoint2 ge:z ?maxZ2 ;
               ge:x ?maxX2 .
    BIND((?maxZ2 - ?minZ2) AS ?door2Height)
    BIND((?maxX2 - ?minX2) AS ?door2Width)
    
    # Validar dimensões de ambas as portas
    FILTER(?door1Height >= 2.0 && ?door1Width >= 1.0 &&
           ?door2Height >= 2.0 && ?door2Width >= 1.0)
  }
  
  # Determinar se o caminho existe e é viável
  BIND(BOUND(?door1) && BOUND(?door2) &&
       ?door1Height >= 2.0 && ?door1Width >= 1.0 &&
       ?door2Height >= 2.0 && ?door2Width >= 1.0 AS ?pathExists)
  BIND(COALESCE(?roomsVisitedPath, "No path") AS ?roomsVisited)
}