rm(list = ls())
source("01_codigo/01_paquetes_y_configuracion.R")

set_token("pk.eyJ1IjoiYWxlamFuZHJvc3Ryb3p6aWVzcGlub3phIiwiYSI6ImNtYThkeHpnZTA4eXQyanBzODJhNDgyYnkifQ.fOFrKcGxSpCl_rS1AymQgQ")

mapdeck(
  style = mapdeck_style("light"),
  location = c(-99.1332, 19.4326),
  zoom = 12
)

metro_lineas <- st_read("02_miscelanea/Movilidad Integrada ZMVM.kml",
                        layer = "Lineas del Metro")
metro_estaciones <- st_read("02_miscelanea/Movilidad Integrada ZMVM.kml",
                            layer = "Estaciones Metro")
metrobus_lineas <- st_read("02_miscelanea/Movilidad Integrada ZMVM.kml",
                        layer = "Lineas del Metrobus y Mexibus")
metrobus_estaciones <- st_read("02_miscelanea/Movilidad Integrada ZMVM.kml",
                            layer = "Estaciones Metrobus y Mexibus")

metrobus_lineas <- st_transform(metrobus_lineas, crs = 4326)
metro_lineas <- st_transform(metro_lineas, crs = 4326)

metrobus_estaciones <- st_transform(metrobus_estaciones, crs = 4326)
metrobus_estaciones_proj <- st_transform(metrobus_estaciones, crs = 6372)
metrobus_estaciones_buffer <- st_buffer(metrobus_estaciones_proj, dist = 400)
metrobus_estaciones_buffer <- st_transform(metrobus_estaciones_buffer,
                                           crs = 4326)
metrobus_estaciones_buffer$color <- "#00FF0040"

metro_estaciones <- st_transform(metro_estaciones, crs = 4326)
metro_estaciones_proj <- st_transform(metro_estaciones, crs = 6372)
estaciones_buffer <- st_buffer(metro_estaciones_proj, dist = 400)
estaciones_buffer <- st_transform(estaciones_buffer, crs = 4326)

puntos_de_interes <- read_csv("02_miscelanea/lugares.csv",
                              show_col_types = FALSE)
puntos_de_interes <- puntos_de_interes %>%
  separate(coordenadas, into = c("lat", "lon"),
           sep = ", ", convert = TRUE)
puntos_de_interes <- st_as_sf(puntos_de_interes,
                              coords = c("lon", "lat"), crs = 4326)

mapdeck(
  style = mapdeck_style("light"),
  location = c(-99.1332, 19.4326),
  zoom = 8
) %>%
  add_path(
    data = metro_lineas,
    stroke_colour = "#1f78b4",
    stroke_width = 4,
    tooltip = "Name",   # adjust based on available columns
    layer_id = "lineas_metro"
  ) %>%
  add_path(
    data = metrobus_lineas,
    stroke_colour = "#1f78b4",
    stroke_width = 4,
    tooltip = "Name",   # adjust based on available columns
    layer_id = "lineas_metrobus"
  ) %>%
  add_scatterplot(
    data = puntos_de_interes,
    fill_colour = "categoria",
    radius = 100,
    tooltip = "lugar",
    auto_highlight = TRUE,
    layer_id = "puntos_de_interes"
    ) %>% 
  add_polygon(
    data = estaciones_buffer,
  # fill_colour = "blue",
    fill_opacity = 100,
    tooltip = "StationName",
    layer_id = "estaciones_radio"
  ) %>%
  add_polygon(
    data = metrobus_estaciones_buffer,
    fill_colour = "color",
    tooltip = "StationName",
    layer_id = "metrobus_estaciones_radio"
  )


