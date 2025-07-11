PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX envm: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>

ASK {
  ?rb a envm:RigidBody ;
      envm:hasName "Pen1" ;
      envm:hasStandardForm ?rb_volume .
  ?rb_volume a envm:Cylinder ;
             envm:hasSweepingPlane ?rb_sweeping_plane .
  ?rb_sweeping_plane a envm:CircularPlane3D ;
                     envm:radius ?rbsp_size .

  ?place a envm:Place ;
         envm:hasName "P2" ;
         envm:hasStandardForm ?place_volume .
  ?place_volume a envm:Block ;
                envm:hasSweepingPlane ?place_sweeping_plane .
  ?place_sweeping_plane a envm:Rectangle3D ;
                        envm:diagonal ?placesp_size .

  FILTER (?rbsp_size <= 0.5 * ?placesp_size)
}