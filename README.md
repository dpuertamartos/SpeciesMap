# SpeciesMap

Website deployed in: https://dpuerta.shinyapps.io/speciesmap/

- The webapp offers a map interface in which observations of species are shown.

- Created using shiny/R by @dpuertamartos to apply for a position as shiny developer in Appsilon

- App is structured in five shinyModules in R/ folder
```
mapGen.R
filterMod.R
timeLines.R
speciesArea.R
speciesSelected.R
```
- App has two helper functions in R/ folder
```
conditional_input_filter.R
filter_data.R
```
- app.R has ui function and server function divided R/folder, it is wrapped in myApp() function
```
ui.R
server.R
app.R
```
- The app is creacted as package, to simplify the deploy there's a simple *app.R* in the root. Code:
```
pkgload::load_all(".")
myApp()
```


<br>

## Tests:

```
devtools::test()
```

![Tests image](https://i.imgur.com/hit2zKo.png)

<br>

## Functionalities:

Current version offer the following functionalities separated in different shinyModules:

```
mapGen.R
```

**Generates a interactive map, with markers for each observation.**

1. Markers are dinamically clumped.

2. Markers are colored depending of the amount of specimens of the observation. 

3. Shows a legends in bottom left of map.

4. Popup when the user click a marker. Popup includes image and others.

<br>

```
filterMod.R
```

**Generates a year filter (slider) and a filter by scientific name/vernacular name, applies the filters to the dataframe**

1. Scientific name/vernacular name filter is selected with a radio button.

2. When you start writing a name, it gives suggestions based on the names of our database. 

3. When a name is finally selected. Applies the filter showing observations only for that species.

4. Produces a slider to filter by the year of the observations.

<br>

```
speciesArea.R
```

**Shows the most frequent observations in the observed map area**

1. Creates a dynamic horizontal graph bar with the most frequent species observations inside of the current map bounds.

2. If you zoom in, zoom out, or move the graph is re-rendered with the new data. 

<br>

```
speciesSelected.R
```

**Generates a text suggesting you to click a marker, dinamically render marker id**

1. When a marker is clicked render the id of the observation in the top side of the image.

<br>

```
timeLines.R
```

**Generates a time series graph when a species is selected using filter**

1. If scientific name or vernacular name filter is active, generates the graph.

2. Time series graph is dinamically adjusted depending of the years selected by the year filter slide. 

<br>

## App arquitecture:

![App arquitecture image](https://i.imgur.com/qTkFQ5K.png)

<br>

## Data engineering:

Below are represented:
- Pipeline used to obtain the smart data from the raw data
- File and script organization in the github folder

![Data engineering image](https://i.imgur.com/h8Muxxn.png)

<br>

## TODO LIST (future expansion of the app):

- [x] Show images of the animals, fill data with images of same species when there's no image provided

- [ ] #1 Let user select day/night/all observations and change map color to dark when required  

- [ ] #2 Let user filter by season 

- [ ] #3 Render more information when marker is clicked (day, night, lat, long, season) #2

- [ ] #4 Associate radius of the marker to distance of observation 

- [ ] #5 Improve styling

- [ ] #6 End-to-end testing with headless browser



