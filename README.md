
## Structure

```
/data
/images
/notebooks
/SQL
/src
PPT
README
```

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

Secondly, web-scraping was used on [Playback.fm](https://playback.fm/charts/top-100-songs) to obtain a dataset on music top charts between years 1920-2019.

## Workflow

### 1. Web Scraping + ETL | Python 

Using libraries:
- BeautifulSoup
- Pandas
- Regex

### 2. Joining tables and querying | SQL

```python
names = pd.read_sql_query("""

SELECT top_names_states.*, song, decade
	FROM top_names_states
    JOIN 
		(SELECT year
				,decade
                ,song
			FROM (
			SELECT year
				,decade
                ,song
				,all_music.order
				,RANK() OVER (PARTITION BY year order by all_music.order) as ranking
			FROM all_music) AS my_table
			WHERE ranking = 1) as top_chart
	ON top_names_states.Year = top_chart.year;

""", engine)
```

![Final dataset](/images/final_dataset.png)

### 3. Visualization | Tableau

Access [full viz](https://public.tableau.com/app/profile/urska.k/viz/WhatsYourName/Story2) on Tableau Public.

Insert a video from Tableau. Needs to be less than 10 MB - split in two parts.

<video width="630" height="300" src="../../../../../../../../Users/urskak/Downloads/Tableau%20Public%20-%20WhatsYourName%20-%2017%20July%202023.mp4" controls title="Title"></video>


*Conclusion (remove?)*
- *Most popular names of past 100 years (James & Mary) — have very low presence after 2000s.*
- *Large increase (+250%) in name variety after late 1980s.*
- *Longer names (15-letter) introduced after 1980s, with all times median length 8,5 letters.*
- *Pop culture/music influence on naming appears to be stronger after late 1980s. Spike of Kylies, Mariahs and Whitneys.*

## Next steps

1. Get dataset with all music, where a user could choose 3 songs - based on type of music, names would be recommended.
2. Extract all first names of artists, and first names that appear in the song titles, and connect those to the name recommendation.

## Sources

https://data.world/ssa/baby-names-for-us-states-territories

https://playback.fm/charts/top-100-songs

