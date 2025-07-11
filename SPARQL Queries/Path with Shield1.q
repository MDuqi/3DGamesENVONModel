PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?start ?goal ?canCollect ?pathExists ?safePathExists ?shieldUsed ?roomsVisited
WHERE {
  # Ponto inicial
  ge:Player1 ge:hasLocation ?start .
  # Objetivo
  ?goal a ge:Place ;
        ge:isGoal "true"^^xsd:boolean .
  
  # Verificação de coleta do Shield1
  OPTIONAL {
    # Localização de Player1 e Shield1
    ge:Player1 ge:hasLocation ?playerLoc .
    ge:Shield1 ge:hasLocation ?shieldLoc .
    
    # Verificar se estão na mesma localização
    FILTER(?playerLoc = ?shieldLoc)
    
    # Origens das hitboxes
    ge:Player1 ge:hasOrigin ?playerOrigin .
    ?playerOrigin ge:hasPosition ?playerVector .
    ge:Shield1 ge:hasStandardForm ?shieldHitbox .
    ?shieldHitbox ge:hasOrigin ?shieldOrigin .
    
    # Coordenadas
    ?playerVector ge:x ?px ; ge:y ?py .
    ?shieldOrigin ge:x ?sx ; ge:y ?sy .
    
    # Verificar proximidade para coleta (diâmetro ajustado para 3.0)
    BIND(ABS(?px - ?sx) <= 3.0 && ABS(?py - ?sy) <= 3.0 AS ?canCollect)
  }
  
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
    
    # Verificar dimensões de Door2
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
  
  # Verificar espaço livre em Room2 para evitar o raio de ataque
  OPTIONAL {
    # Localização de Enemy1
    ge:Enemy1 ge:hasStandardForm ?enemyHitbox .
    ?enemyHitbox ge:hasOrigin ?enemyLoc .
    # Coordenadas de Enemy1
    ?enemyLoc ge:x ?ex ; ge:y ?ey .
    # Raio de ataque (ajustado para 10.0 no teste)
    ge:Enemy1 ge:attackRadius ?attackRadius .
    # Dimensões de Room2
    ?intermediate1 ge:hasBoundingBox ?room2BBox .
    ?room2BBox ge:hasMinimumPoint ?room2Min ;
               ge:hasMaximumPoint ?room2Max .
    ?room2Min ge:x ?room2MinX ; ge:y ?room2MinY .
    ?room2Max ge:x ?room2MaxX ; ge:y ?room2MaxY .
    BIND((?room2MaxX - ?room2MinX) AS ?room2Width)
    BIND((?room2MaxY - ?room2MinY) AS ?room2Length)
    
    # Calcular espaço livre (aproximação)
    BIND(?room2Width - (2 * ?attackRadius) AS ?freeWidth)
    BIND(?room2Length - (2 * ?attackRadius) AS ?freeLength)
    
    # Estado do escudo
    ge:Shield1 ge:isCollected ?isShieldCollected .
  }
  
  # Determinar se o caminho existe, é seguro e o uso do escudo
  BIND(BOUND(?door1) && BOUND(?door2) &&
       ?door1Height >= 2.0 && ?door1Width >= 1.0 &&
       ?door2Height >= 2.0 && ?door2Width >= 1.0 AS ?pathExists)
  BIND(COALESCE(?roomsVisitedPath, "No path") AS ?roomsVisited)
  BIND(COALESCE(?canCollect, false) AS ?canCollect)
  BIND(COALESCE(?freeWidth > 1.0 || ?freeLength > 1.0, false) AS ?safePathExists)
  BIND(COALESCE(?canCollect = true && ?safePathExists = false, false) AS ?shieldUsed)
}