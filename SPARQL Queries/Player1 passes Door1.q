PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?playerHeight ?playerDiameter ?doorHeight ?doorWidth ?canPass
WHERE {
  # Dimensões de Player1
  ge:Player1 ge:hasStandardForm ?hitbox .
  ?hitbox ge:sweeping_length ?playerHeight ;
          ge:hasSweepingPlane ?sweepingPlane .
  ?sweepingPlane ge:radius ?playerRadius .
  BIND((2 * ?playerRadius) AS ?playerDiameter)

  # Dimensões de Door1
  ge:Door1 ge:hasBoundingBox ?bbox .
  ?bbox ge:hasMinimumPoint ?minPoint ;
        ge:hasMaximumPoint ?maxPoint .
  ?minPoint ge:z ?minZ ;
            ge:y ?minY .
  ?maxPoint ge:z ?maxZ ;
            ge:y ?maxY .
  BIND((?maxZ - ?minZ) AS ?doorHeight)
  BIND((?maxY - ?minY) AS ?doorWidth)

  # Verificação se pode passar
  BIND(
    ( (?doorHeight >= ?playerHeight) && (?doorWidth >= ?playerDiameter) ) 
    AS ?canPass
  )
}