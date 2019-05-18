var=$(for filename in estaciones/*.csv; do x=$(echo $filename | grep -o -P '(?<=/).*(?=\.)'); sed 's/\([0-9][0-9]*\),\([0-9][0-9]*\)/\1.\2/g' $filename | awk '{gsub(/;/, ","); print}' | awk '{print gensub(/([a-zA-Z]*),([a-zA-Z]*),([a-zA-Z]*),([a-zA-Z]*)/,"\\1,\\2,\\3,\\4,ESTACION",1)}' | awk '{print gensub(/,([0-9]*)\.([0-9]*)/, ",\\1.\\2,'$x'", 1)}'; done) 
echo "$var" | sed '2,${/FECHA/d;}' | sed 's/\([a-zA-Z]*\),\([a-zA-Z]*\),\([a-zA-Z]*\),\([a-zA-Z]*\),\([a-zA-Z]*\)/\1,\2,MES,ANIO,HORA,\3,\4,\5/' | sed 's/\([0-9]*\)\/\([0-9]*\)\/\([0-9]*\),\([0-9]*\):\([0-9]*\):\([0-9]*\)/\1\/\2\/\3,\4:\5:\6,\2,\3,\4/' > estaciones.csv
csvsql --query 'SELECT ESTACION AS "Nombre de la estacion",  MES AS "Mes", AVG(VEL) AS "Velocidad" FROM estaciones GROUP BY ESTACION, MES ORDER BY ESTACION ASC, MES ASC' estaciones.csv > velocidad-por-mes.csv
csvsql --query 'SELECT ESTACION AS "Nombre de la estacion",  ANIO AS "Anio", AVG(VEL) AS "Velocidad" FROM estaciones GROUP BY ESTACION, ANIO ORDER BY ESTACION ASC, ANIO ASC' estaciones.csv > velocidad-por-ano.csv
csvsql --query 'SELECT ESTACION AS "Nombre de la estacion",  HORA AS "Hora", AVG(VEL) AS "Velocidad" FROM estaciones GROUP BY ESTACION, HORA ORDER BY ESTACION ASC, HORA ASC' estaciones.csv > velocidad-por-hora.csv
