# clasificacion_canciones
Contando con datasets con info de canciones, artistas, y reproducciones, hacemos: análisis y limpieza de datos, creación del modelo de datos relacional, búsqueda de KPIs de valor para el negocio, identificación de errores, y generación, entrenamiento y evaluación de modelos de ML para la clasificación de canciones por género musical

## Objetivos
1.	Diseñar e implementar un modelo de datos relacional que permita a la compañía llevar a cabo un análisis de sus datos y extraer métricas y KPIs útiles para el negocio.
2.	Identificar patrones de errores e incidencias dentro de los sistemas de la compañía gracias a los datos proporcionados.
3.	Generar un modelo de machine learning para automatizar la tarea de clasificación de canciones por su género.

## 1. Modelo relacional y KPIs de negocio
Inicialmente recibimos diferentes documentos .json (en la carpeta ‘data’) con:
- Información sobre las canciones (ID de la canción, duración, género musical, disco y autor).
- Datos de los artistas (ID de la canción, los artistas principales y colaboradores, la discográfica y el coste de los derechos de la canción).
- Fecha de publicación de cada canción (ID de la canción, día, mes y año).
- Las reproducciones de estas canciones durante el mes de septiembre (ID de la canción, reproducciones por cada uno de los días de septiembre y número total de reproducciones).
- Listas de reproducción en las que están guardadas las canciones (ID de la canción y listas).
- Los usuarios que han agregado cada canción a favoritos (ID de la canción y usuarios).

Después de hacer un análisis y limpieza de los datos, hemos creado un modelo relacional para la base de datos de la compañía que trata de optimizar el uso de los recursos y de reducir tanto el peso de los datos como el tiempo de carga de los mismos (en la carpeta ‘Modelo y scripts SQL’).

Hemos creado diferentes tablas: 
- codigos: una nueva tabla en la que relacionamos el dato de ID de la canción con un código numérico único para cada uno de los temas. Esta tabla está relacionada con el resto y nos ha permitido cambiar las columnas de ID de canción del resto de tablas (Ej: blues.00000.wav) por el código numérico (1), reduciendo enormemente el peso de la base de datos. La primary key ‘codigo’ es foreign key en el resto de tablas del modelo.
- canciones: en esta tabla hemos reunido datos sobre las canciones que antes se encontraban en diferentes tablas. Además del código único de la canción, tenemos el autor, la discográfica, el coste de derechos, la duración, el género, el disco y la fecha de publicación.
- colaboradores: pensando en la futura escalabilidad de la base de datos hemos creado una tabla aparte que relaciona cada colaborador con el código de la canción en la que participó. De esta manera no importa el número de colaboradores que pueda tener una canción.
- listas: esta tabla la hemos dejado igual que tras el análisis y tratamiento de datos, únicamente cambiando el ID canción por el código.
- favoritos: esta tabla la hemos dejado igual que tras el análisis y tratamiento de datos, únicamente cambiando el ID canción por el código.
- popularidad_mes: esta tabla contiene el código único de cada canción y el número total de reproducciones de septiembre de cada una de ellas (más abajo explicamos por qué el número total de reproducciones de septiembre y no el número total de reproducciones). 
- popularidad_dia: esta tabla contiene una columna con el código único de cada canción, otra con el día de septiembre y otra con el número de reproducciones correspondiente a esa canción y ese día. Se planteó así para facilitar las futuras consultas en SQL.

Puede verse el modelo de datos y las conexiones en la siguiente imagen: 
![image](https://github.com/user-attachments/assets/63342ede-4f08-4dee-8e14-f8f39fc51a86)

Los tipos de datos están asignados según interés de cara a las consultas:
- Los datos numéricos tales como la duración o las reproducciones son INT ya que se trata de números que deben ser enteros. Los códigos únicos de canción son INT para una mayor claridad a la hora de visualizar las consultas.
- El coste por los derechos de la canción es DECIMAL, ya que se trata de valor monetario. 
- El resto de datos son CHAR con una longitud específica para cada variable. Hemos elegido CHAR ya que el tamaño de entrada de los datos es coherente y no varía notablemente.

También hemos introducido tipos de datos por defecto en el modelo de datos por si en algún momento entran nuevos registros que no contengan información de alguna de las tablas, por ejemplo: si entra un nuevo registro sin información de coste por derechos, se rellena automáticamente con un cero.

Utilizando consultas de SQL sobre la base de datos se han analizado los datos y extraído métricas para el negocio (en la carpeta ‘Modelo y scripts SQL’), comprobadas posteriormente en el notebook con python (en el notebook ‘clasificacion_canciones.ipynb’). Algunas pedidas por negocio y otras propuestas por el equipo por su posible interés para negocio: 
1.	La media diaria de reproducciones durante septiembre: 49.977 reproducciones.
2.	El número total de reproducciones (durante el mes de septiembre): 1.499.321.619 rep.
3.	Días del mes en el que se han reproducido más canciones: 29 (52.103.482 rep.), 12 (51.671.536 rep.), 14 (50.985.893 rep.), 30 (50.952.206 rep.) y 11 (50.925.137 rep.).
4.	Día del mes en el que suelen publicarse más canciones: el día 20 (38 canciones).
5.	Los 5 usuarios que más canciones han añadido a favoritos: ivk_58 (9 canciones), ayy_86 (8), clp_71 (8), syh_95 (8) y wfs_98 (8).
6.	Los 5 usuarios que menos canciones han añadido a favoritos: aaa_0 (1 canción), omg_53 (1), omg_55 (1), omg_56 (1), omg_61 (1). No creemos que sea relevante este KPI ya que hay muchos usuarios que han añadido únicamente 1 canción. 
7.	Las 10 discográficas que más dinero han recibido: Merge Records (240.371,70€), 4AD (124.224,90€), Interscope Records (119.518,98€), RCA Records (115.936,86€), Sun Records (109.791,74€), Wind-Up Records (108.225,18€), XL Recordings (107.870,49€), Arista Records (105.844,75€), Atlantic Records (105.254,98€), y Rough Trade Records (102.346,73€).
8.	Los 3 artistas que más colaboraciones con otros artistas han hecho: J.Cole (4 colaboraciones), Zayn Malik (4) y Protoje (4).
9.	Los 3 artistas que han interpretado menos canciones de otros compositores: Ziggy Marley (1 canción), Rakim (1) y Joe Pass (1). No creemos que sea relevante este KPI ya que hay muchos artistas que han interpretado únicamente 1 canción de otro compositor. 
10.	El número de canciones que hay de cada género: Hay 100 canciones de cada género (100 de blues, 100 de classical, 100 de country, 100 de disco, etc.)
11.	Los discos más escuchados: jazz3 con 20.423.383 de reproducciones, country2 con 17.837.036 de reproducciones y metal 9 con 16.597.921 de reproducciones.
12.	La media de canciones que tiene un disco: 5 canciones.
13.	Cuantía total por género que cobran las 5 discográficas que han recibido más dinero: rock (87.787,48€), jazz (87.181,95€), country (82.634,04€), classical (80.361,17€), hiphop (76.459,08€), blues (72.498,38€), reggae (69.557,45€), metal (54.173,61€), pop (50.534,55€) y disco (48.656,48€).
14.	Duración total de cada disco: hay 200 discos, por lo que esta información no se puede ver de una manera clara. Los de mayor duración son: jazz3 (2175 seg), metal19 (1820 seg) y pop16 (1820 seg). Los de menor duración: reggae0 (99 seg), rock9 (129 seg) y rock14 (159 seg). 
15.	La media de duración de los discos: 722,45 segundos.
16.	Las canciones más veces incluidas en listas de reproducción: metal.00028, disco.00049, classical.00014, jazz.00066, metal.00096, reggae.00018, blues.00045, metal.00047 y reggae.00093 han sido las más veces incluidas en listas (99 veces cada una).
17.	Las 5 canciones más veces incluidas en favoritos: disco.00040 y reggae.00049 (marcadas como favoritas 2996 veces), pop.00087 (2992 veces), reggae.00024 (2989 veces) y blues.00055 (2985 veces).

## 2. Limpieza de datos
Tras un análisis inicial de los datos (en el notebook ‘clasificacion_canciones.ipynb’), encontramos:

Datos nulos:
- 18 nulos en la duración de las canciones. La duración de estos registros se ha rellenado con la mediana (para que el valor no se vea tan afectado por outliers) de la duración de las canciones de cada autor. 
- Había 6 nulos en el día de publicación de las canciones, 9 nulos en el mes y 17 en los años. Dada la alta cantidad de datos nulos y erróneos, decidimos no eliminar los registros para conservar el resto de datos, sustituyendo todos los valores por un valor común.
- Había 599 nulos en las reproducciones diarias de las canciones durante el mes de septiembre. Decidimos sustituir estos datos por la mediana (para que el valor no se vea tan afectado por outliers) de las reproducciones de cada canción durante el mes de septiembre.

Datos erróneos: 
- Había canciones con duración 0 seg, cercanas a 0 seg o muy cortas. En los datos proporcionados por la empresa teníamos pistas de audio con duración 30 seg de cada una de las canciones, por lo que entendemos que no existen canciones con una duración inferior a 30 seg. Había 19 canciones con duración inferior a 30 seg. La duración de estos registros se ha rellenado con la mediana de la duración de las canciones de cada autor. 
- Había 26 registros con coste negativo por derecho de las canciones. Estos datos negativos tenían un orden de magnitud similar al conjunto del resto de datos, por lo que entendimos que el error se encontraba en el signo negativo. Por ello decidimos pasar los valores negativos a positivos. 
- Encontramos 84 datos erróneos en el día de publicación de las canciones (días por debajo de 1 o por encima del día máximo de cada mes), 10 datos erróneos en el mes de publicación (meses inferiores a 1) y 66 datos erróneos en los años de publicación (19 registros negativos, 19 de año 0, 13 de año 1 y 15 de año 2). Dada la alta cantidad de datos erróneos, decidimos no eliminar los registros para conservar el resto de datos, sustituyendo todos los valores por un valor común.
- En la mayoría de registros el total de reproducciones de la canción es inferior a la suma de todas las reproducciones de esa canción durante el mes de septiembre, lo que no tiene sentido. Hemos decidido utilizar como dato agregado el total de reproducciones de septiembre en vez de el total de reproducciones. 
- Había 695 registros negativos en las reproducciones diarias de las canciones durante el mes de septiembre. Decidimos sustituir estos datos por la mediana de las reproducciones de cada canción durante el mes de septiembre.

Datos que contradicen reglas de negocio: 
- Según negocio las duración de las canciones no puede ser superior a 13 min, había 24 canciones con duración superior a 13 min. La duración de estos registros se ha rellenado con la mediana de la duración de las canciones de cada autor. 
- Según negocio el límite de pago por los derechos de una canción pop es de 5.000€. Había 8 canciones pop que superaban el límite de pago. Al superar ese límite por muy poco y ser todas las canciones del mismo género, decidimos ajustar esos datos al máximo: 5.000€.

## 3. Metodología de ML
En primer lugar, identificamos el problema y el objetivo principal que queríamos lograr con el modelo. Con este modelo queríamos poder predecir el género musical al que pertenece una canción. Contábamos con datos etiquetados, ya que todas las canciones estaban asociadas a un género musical, por lo que se trataba de un problema de clasificación. 

Consideraremos que el modelo es aceptable cuando tenga un porcentaje de acierto alto para todas las clases (más del 80%), y pueda ser re-entrenado y ejecutado dentro de un tiempo aceptable. En ejecuciones diarias o mensuales el tiempo no suele ser relevante, mientras que en ejecuciones en tiempo real sí lo es.

Después pensamos qué datos de todos los disponibles (en la carpeta ‘data’) íbamos a utilizar para entrenar los modelos. Decidimos que los datos de características de las canciones (los archivos csv con las características de los audios de 30 segundos y de sus particiones de 3 segundos) en principio eran suficientes y no hacía falta agregar datos de la parte de negocio analizados anteriormente para obtener KPIs e insights de valor para la compañía. Ninguno de esos datos nos parecía ser relevante para la detección del género de una canción. 

Seguidamente analizamos las diferentes opciones de algoritmos a aplicar. Al final pensamos que la mejor opción sería probar distintos algoritmos y comparar los resultados de los mismos para finalmente elegir el modelo que mejor funcionara (en el notebook ‘clasificacion_canciones.ipynb’). 

Quisimos probar modelos primero con los datos del archivo de características de 30 segundos. Utilizamos una normalización de datos robusta (Robust Scaler) ya que existían outliers en los datos de las diferentes variables. Hicimos una división de datos de train y test del 75% y 25% respectivamente, y tuvimos que tratar nuestros datos ‘y’, las clases, de diferentes maneras dependiendo de los modelos (nombres de las clases tipo ‘object’, One Hot Encoder, o valores numéricos del 0 al 9 ya que se trataba de 10 clases). Probamos diferentes modelos: árboles de decisión, regresión logística, K vecinos más cercanos, naive bayes, y modelos ensemble (random forest, gradient boosting y adaboost). Utilizamos Grid Search CV con casi todos para probar los diferentes hiperparámetros de los modelos y poder quedarnos con el mejor de cada tipo. Al tratarse de un problema de clasificación decidimos quedarnos con la métrica de accuracy (precisión).

Después probamos con los datos del archivo de características de las particiones de 3 segundos de cada canción. Con estos datos probamos los modelos de árboles de decisión, regresión logística, SGD, K vecinos más cercanos y modelos ensemble (random forest, gradient boosting y adaboost). 

Con los resultados de los modelos utilizando los diferentes datasets, nos damos cuenta de que los resultados del dataset de características de 3 segundos son mucho mejores que los de 30 segundos. Esto se debe a que el dataset de 30 segundos calcula los estadísticos de cada parámetro (media y varianza) para la señal completa, mientras que el dataset de 3 segundos, al dividir cada canción en 10 partes, permite calcular 10 estadísticos de cada canción por cada parámetro, por lo que la discretización de las señales es mucho mejor, y permite definir de manera más precisa las propiedades del audio.

![image](https://github.com/user-attachments/assets/f74fe066-b38b-4279-979f-55ff36689d01)

Utilizando el mejor modelo obtenido (LightGBM Classifier) hemos sacado un archivo de predicciones en el que podemos comparar de todas las canciones el género que hemos predicho con el modelo y cuál era el género real de la canción (en la carpeta ‘Archivos Predicciones‘).

Por último, hemos querido utilizar también un modelo de Deep Learning para realizar la clasificación de canciones. Utilizamos directamente los datos del dataset de 3 segundos ya que las redes neuronales necesitan una mayor cantidad de datos para funcionar bien. Tras una serie de pruebas, se construyó una red neuronal según la siguiente topología:

- Todas las capas se han construido de tipo “Dense”.
- Capa de entrada de 2048 neuronas.
- 6 capas ocultas de 1024, 512, 254, 128, 64 y 32 neuronas, respectivamente.
- Capa de salida de 10 neuronas (una por cada género de canción a identificar).
- Las neuronas de salida fueron configuradas con una función de activación softmax, para el cálculo de probabilidad, mientras que en el resto se emplearon funciones tipo relu, que evitan valores negativos de salida.
- Además, a la salida de capa se añadieron dos capas adicionales: una del tipo “BatchNormalization”, para normalizar los resultados de salida de cada capa, y otra del tipo “Dropout” al 20%, para desactivar aleatoriamente un 20% de las neuronas de cada capa, consiguiendo que la información que vea cada neurona sea más diversa y consigan una mayor especialización. 
- Se empleó el optimizador Adam con una tasa de aprendizaje del 0.001.
- Como parámetro de pérdida se empleó el “sparse_categorical_crossentropy”, y como métrica, la precisión del modelo.
- Para el entrenamiento del modelo se emplearon 600 epochs y un conjunto de validación interno igual al 20% de los datos de entrenamiento.

Con dicho modelo, se consiguió una precisión con los datos de entrenamiento del 99%, y del 93% con los de test. Además, la matriz de confusión muestra un porcentaje de acierto bastante alto para todos los géneros de canción:
![image](https://github.com/user-attachments/assets/3f552c29-a132-44cd-a814-f324a034c3d4)

Adicionalmente, se testearon técnicas de data augmentation con el objetivo de afinar aún más los resultados obtenidos. De tal manera, a partir de los ficheros de audio .wav, se obtuvieron todos los parámetros estadísticos por cada segundo de audio, triplicando la cantidad de datos inicial con respecto al dataframe de 3 segundos. No obstante, los resultados obtenidos no mejoraron a los ya obtenidos con el dataset de 3 segundos, lo que muestra que la cantidad de datos ya era la adecuada. 

En un último test, se probó a filtrar aquellas variables con más outliers para los géneros con menor porcentaje de acierto, para comprobar si la clasificación de los mismos mejoraba, pero una vez más, los resultados fueron los mismos, lo que indica que, con la calidad de los datos actuales, ya se había logrado un porcentaje de acierto difícil de mejorar.

De nuevo, hemos utilizado el modelo de Deep Learning con mejores resultados para sacar un archivo de predicciones (en la carpeta ‘Archivos Predicciones‘).

Consideramos que los resultados de los modelos son muy buenos y consiguen cubrir las necesidades de negocio. Sin embargo, proponemos próximos pasos a seguir para mejorar la calidad de los datos y los modelos: 

- Analizar el origen de los datos de duración, fechas de publicación, coste por derechos y reproducciones totales de las canciones para identificar la fuente de los datos nulos y erróneos. 
- Testear nuevas técnicas de audio data augmentation, como variar la velocidad de reproducción de los audios sin alterar la duración, añadir efectos de reverberación, máscaras de tiempo y frecuencia, etc.

