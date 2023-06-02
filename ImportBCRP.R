
## Importar series BCRP con API 
#---------------------------------

setwd("D:/ANDRES/Documentos/Seriesdetiempo/")


#install.packages("dplyr")

#remove.packages("rlang")
#install.packages("rlang")
library(rlang)
library(dplyr)
library(jsonlite)

#PN38705PM:  Índice de precios al consumidor (IPC) 
#PN39521PM:  IPC Alimentos y energía 
#PN39521PM:  IPC Alimentos y bebidas 
#PN38707PM:  IPC Sin alimentos y energía 

# URL y parámetros de la solicitud
url_base <- "https://estadisticas.bcrp.gob.pe/estadisticas/series/api/"
metadato <- c('PN38705PM','PN39521PM','PN39521PM','PN38707PM')   #[códigos de series mensuales]
formato <- "/json"
per <- "/2004-1/2023-4"
#url <- paste0(url_base, metadato[i], formato, per,sep="")

#Generating columns of characters with each ID
#metadato <- c('PN38705PM','PN39521PM','PN39521PM','PN38707PM')

for (i in 1:length(metadato)){
  #  tryCatch({
  # Indicamos el ID, el formato, las fechas y el idioma. Llamamos "url" a esta combinación
  url <- paste0(url_base, metadato[i], formato, per,'/ing',sep="")
#  url <-paste('https://estadisticas.bcrp.gob.pe/estadisticas/series/api/',metadato[i],'/json/per/ing', sep="") 
  # Descargamos el url indicado
  tmp1  <- fromJSON(readLines(url, warn="F"))
  # Cambiamos el formato de los datos y cambiamos el valor de las variables con missing values.
  dato <-as.data.frame(lapply(tmp1$periods, function(y) gsub("n.d.", "-99999.99", y))) 
  # Cambiamos el nombre del archivo usando el ID que lo identifica.
  names(dato) <- c("name",paste("",metadato[i],"",sep=""))
  # Creamos un nuevo documento indicando el formato
  # El formato "dta" se usa en el software Stata
#  write.dta(dato, file=paste(metadato[i],'.dta', sep=""))
  # El formato "csv" se puede usar en distintos softwares incluído Excel
  write.csv2(dato, file=paste(metadato[i],'.csv', sep=""))
  #  }, error=function(e){})
}


df <- read.csv("PN39521PM.csv", sep = ";")


# Obtener el número total de variables
num_variables <- ncol(df)

# Cambiar los nombres de las variables
nuevos_nombres <- c("Id", "Tiempo", "IPC Alimentos y energía")
for (i in 1:num_variables) {
  names(df)[i] <- nuevos_nombres[i]
}






























# Realizar la solicitud GET
response <- GET(url)
response_content <- content(response, "text")
response_json <- fromJSON(response_content)

# Obtener los datos del período y el índice de precios
periodos <- response_json$periods
price_index <- c()
for (i in 1:length(periodos)) {
  valores_list <- periodos[[i]]$values
  for (w in valores_list) {
    w <- as.numeric(w)
    price_index <- c(price_index, w)
  }
}

# Obtener las fechas
fechas <- sapply(periodos, function(i) i$name)

# Crear el dataframe
df <- data.frame(Fechas = fechas, IPC_senergia = price_index)

# Guardar el dataframe como archivo .dta
write.dta(df, "IPC_se.dta")


