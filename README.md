# SpeciesMap

Website deployed in: https://dpuerta.shinyapps.io/speciesmap/

The webapp offers a map interface in which observations of species are shown.

## Functionalities:

Current version offer the following functionalities separated in different shinyModules:


### - mapGen 

**Generates a interactive map, with markers for each observation.**

1. Markers are dinamically clumped.

2. Markers are colored depending of the amount of specimens of the observation. 

3. Shows a legends in bottom left of map.

4. Popup when the user click a marker. Popup includes image and others.



### - filterMod

**Generates a year filter (slider) and a filter by scientific name/vernacular name, applies the filters to the dataframe**

1. Scientific name/vernacular name filter is selected with a radio button.

2. When you start writing a name, it gives suggestions based on the names of our database. 

3. When a name is finally selected. Applies the filter showing observations only for that species.

4. Produces a slider to filter by the year of the observations.



### - speciesArea

**Shows the most frequent observations in the observed map area**

1. Creates a dynamic horizontal graph bar with the most frequent species observations inside of the current map bounds.

2. If you zoom in, zoom out, or move the graph is re-rendered with the new data. 



### - speciesSelected

**Generates a text suggesting you to click a marker, dinamically render marker id**

1. When a marker is clicked render the id of the observation in the top side of the image.



### - timeLine

**Generates a time series graph when a species is selected using filter**

1. If scientific name or vernacular name filter is active, generates the graph.

2. Time series graph is dinamically adjusted depending of the years selected by the year filter slide. 


## App arquitecture:

![App arquitecture image](https://i.imgur.com/qTkFQ5K.png)




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


