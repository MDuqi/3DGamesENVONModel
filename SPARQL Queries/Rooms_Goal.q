PREFIX ge: <http://www.semanticweb.org/matheusduque/2025/3DGamesENVONModel#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?place ?isGoal
WHERE {
  ?place a ge:Place ;
         ge:isGoal ?isGoal .
}