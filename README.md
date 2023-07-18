
## Structure

/notebooks
/src
...


# Hi, What's your name?

Name represents and is a part of each individual's personal identity.

Naming their child has always played an important role for parents. When choosing a name, they might want to choose something unique, but not too different; something short and easily pronounced or more complex; gendered or unisex; more traditional or modern. 

A name can reflect popular cultural trends, that originate from areas of art, literature, fashion, film and music of the time.

## Objective

Firstly, understand name popularity evolution throughout the years, and observe the effect of pop culture/music on naming.

Secondly, create a name recommendation prototype as an output, where the user inputs selected parameters, including personal music preference.

## Datasets & limitations

This analysis focuses on historical data of given names in the USA, acquired from the [US Social security administration](https://data.world/ssa/baby-names-for-us-states-territories). A large dataset with over 6 million records was obtained, that encompasses over 100 years of historical data (1920-2021). 

Limitations:

- Only including names at least 2 characters long, and records with min. 5 occurrences per year in any state.
- The sex associated with a name may be incorrectly inserted at the time of registry.
- Many people born before 1937 never applied for a Social Security card, so their names are not included.

Initial columns from the dataset: 

(insert table)

Secondly, web-scraping was used on [Playback.fm](https://playback.fm/charts/top-100-songs) to obtain a dataset on music top charts between years 1920-2019.

## Workflow

### 1. Web-scraping, preprocessing + ETL | Python 

Using libraries BeautifulSoup, Pandas, Regex.

Insert a final clean table screenshot, with all the columns. (both datasets)

### 2. Joining tables and querying | SQL

Insert a piece of code (SQL).

### 3. Visualization | Tableau

Insert a video from Tableau. Needs to be less than 10 MB - split in two parts.

<video width="630" height="300" src="../../../../../../../../Users/urskak/Downloads/Tableau%20Public%20-%20WhatsYourName%20-%2017%20July%202023.mp4" controls title="Title"></video>

## Conclusion

- Most popular names of past 100 years (James & Mary) — have very low presence after 2000s.
- Large increase (+250%) in name variety after late 1980s.
- Longer names (15-letter) introduced after 1980s, with all times median length 8,5 letters.
- Pop culture/music influence on naming appears to be stronger after late 1980s. Spike of Kylies, Mariahs and Whitneys.

## Sources

https://data.world/ssa/baby-names-for-us-states-territories

https://playback.fm/charts/top-100-songs

