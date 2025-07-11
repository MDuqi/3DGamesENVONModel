PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?hitbox ?origin ?localRef ?function ?sweepingLength ?radius ?sweepingDirX ?sweepingDirY ?sweepingDirZ
WHERE {
  ?Player1 a ge:PlayableCharacter.
  OPTIONAL { ge:Player1 ge:hasStandardForm ?hitbox .
             ?hitbox a ge:Cylinder ;
                     ge:hasSweepingPlane ?sweepingPlane ;
                     ge:hasSweepingDir ?sweepingDir ;
                     ge:sweeping_length ?sweepingLength .
             ?sweepingPlane ge:radius ?radius .
             ?sweepingDir ge:x ?sweepingDirX ;
                          ge:y ?sweepingDirY ;
                          ge:z ?sweepingDirZ .
           }
  OPTIONAL { ge:Player1 ge:hasOrigin ?origin . }
  OPTIONAL { ge:Player1 ge:hasLocalReferenceFrame ?localRef . }
  OPTIONAL { ge:Player1 ge:hasFunction ?function . }
}