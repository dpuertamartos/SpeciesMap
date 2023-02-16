# SpeciesMap

Website deployed in: https://dpuerta.shinyapps.io/speciesmap/

The webapp offers a map interface in which observations of species are shown.

Current version offer the following functionalities:
  #Filtering observations :
  
  -Filter observations per year (using slider)
  -Filter observations per scientific name OR per common name
  
  #When a species (per scientific name or per common mae) is selected, shows a time series of the observations of said species for selected years
  
  #Shows the most common observations in the area of the map we're zoomed in (it dinamically adjust)
  
  #The map groups the markers when they're cumpled, this is dinamically adjusted. 
  
  #Markers have different colors depending of how many individuals were reported in the observation
  
  #When clicking a marker it shows a popup with its info
  
  #NEW!! When clicking a marker it shows a photo of the species (original photo of the observation if available, if not it is filled)
  
 
TODO LIST:

#1: LET USER SELECT DAY/NIGHT/ALL OBSERVATIONS AND CHANGE MAP COLOR TO DARK

#2 RENDER MORE INFORMATION WHEN A MARKER IS CLICKED (DAY, NIGHT, SEASON, LATITUDE, LONGITUDE...)

#3: LET USER SELECT SUMMER/WINTER/SPRING/FALL OBSERVATIONS

#4: ASSOCIATE RADIUS TO DISTANCE OF OBSERVATION?

#5: IMPROVE AESTHETIC OF DEFAULT VIEW

#6: USE CSS TO STYLE DASHBOARD MORE

#8: FIX BROKEN TESTS

#9: END-TO-END TESTING

#10: DEPLOY IN SHINYAPPS


