# Database Query Project

This repository contains SQL queries and responses to various questions across nine different databases. Each database corresponds to a specific domain, and the queries showcase how to retrieve valuable information from these datasets.
These databases were created as part of the ITU Database Systems course.


## Databases Included:

1. [Database 1- Cars]
2. [Database 2- Chefs_and_recipes ]
3. [Database 3- Dancers]
4. [Database 4 - Fabrics]
5. [Database 5 - Football]
6. [Database 6 - Movies]
7. [Database 7- Plants]
8. [Database 8 - Songs]
9. [Database 9- Viruses]

## About:

These queries represent questions I have diligently solved during my dedicated exploration of the databases. 

## Usage:

Explore the SQL queries organized by databases to find answers to common questions or specific insights within each dataset.

## Answered Questions per database:

### Database 1 - Cars:

1. How many actual cars have been made by VOLVO? 
2. How many different makers has the person with ID = 45 bought from? 
3. How many cars have been sold fewer than 2 times? 
4. What is the licence of the car sold most often? 
5. According to the sellers table, how many people have made at least one sale alone? 
6. How many people have bought cars of all models made by VOLVO? 
7. How many different cars have some problem with one of the -year attributes? 

    

### Database 2 - Chefs and Recipes:

1. How many  chefs have not created any recipes? 
2. How many recipes that have some ingredient(s) of type ‘spice’ has the chef ‘Spicemaster’ mastered? 
3. How many recipes have 3 or fewer steps registered?
4. How many recipes belong to the same cuisine as at least one of their ingredients?
5. What is/are the name of the recipe/s with the most different ingredients of all recipes? 
6. We define the spice ratio of a cuisine as the number of ingredients that belong to it that are of type ‘spice’ divided by the total number of ingredients that belong to the cuisine. Here we consider only cuisines that actually have spices. The highest spice ratio is 1.0, and this sppice ratio is shared by 8 cuisines. How many cuisines share the lowest spice ratio? 
7. How many recipes contain some ingredient of all ingredient types in the same step? 
8. Write a query that outputs the id and name of chefs, and total ingredient quantity (--regardless of units), in order of decreasing quantity, for chefs that have created--recipes in a cuisine with ‘Indian’ in the name, but only considering ingredients that--belong to a cuisine with ‘Thai’ in the name.



### Database 3 - Dancers:

1. How many records in DancerAward have an award that does not exist? 
2. How many distinct dancers have a rank and an award in some contest organized by “DR’? 
3. How many pairs of contests have the same name? 
4. How many distinct dancers have an award, but not a rank, in a contest? 
5. How many records have a rank lower than the average rank of all records in the relation?
6. How many dancers have participated in all contests editions named “Dance Forever”?
7. How many contest names are used by two different organizers?



### Database 4 - Fabrics :

1. How many different elements does the cashmere fabric consist of?
2. How many countries have more than two designers? 
3. How many garments have a price that is lower than the average garment price? 
4. How many garments with missing price values have a type of importance equal to --six?
5. How many main designers have designed garments in all categories that exist in the database?
6. How many designers have collaborated with other designers from 14 different countries? 



### Database 5 - Football :

1. How many clubs are from the city named London? 
2. In the signedwith table, there are three different clubID values that no longer exist in the clubs table. How many players signed with those clubs? 
3. The club named Liverpool has a total of 243 away wins, while the highest number of away wins by any club happens to be 260. How many different clubs jointly have the most away wins? 
4. During the playing career of Andrea Pirlo, he was involved with 319 home goals. As outlined above, this means that while he was signed with different clubs, they scored a total of 319 home goals. How many away goals was Steven Gerrard involved with? 
5. During his illustrious playing career, Bjorn signed with 7 different clubs. Write a query to output the name(s) of the player(s) who signed with the largest number of different clubs. 
6. How many players never signed with a club from the city named London? 
7. London clubs are defined here as clubs from the city named London. All 14 nonLondon clubs have beaten all London clubs away (meaning that the London club was the home team) during some season registered in the database. How many non-London clubs have beaten all London clubs away in a single season?



### Database 6 - Movies :

1. How many entries do not have a registered death date?
2. What is the number of movies in the French language for which the average height of all people involved is greater than 185 centimeters?
3. The movie genre relation does not have a primary key, which can lead to a movie having more than one entry with the same genre. As a result, there are 3 movies in movie genre that have the genre ‘Crime’ assigned to them more than once. How many movies in movie genre have the genre ‘Action’ assigned to them more than once?
4. How many different people acted in movies directed by ‘Ingmar Bergman’?
5. How many movies produced in 2010 have only one actor involved in them?
6. How many are the cases where a specific actor and director collaborated together in more than 12 movies?
7. How many movies produced in 2000 have entries registered in involved for all roles defined in the roles relation?
8. How many people have played a role in movies of all genres in the category ‘Popular’?



### Database 7 - Plants :

1. How many plants belong to the family “Thespesia”?
2. Of the people in the database, 11 have not planted anything. How many of those, who have not planted anything, have the position “Planter”?
3. The total area of the family “Thespesia” is 66.62. What is the total area of the family “Vicia”?
4. The most overfilled flowerbed is planted to 105% capacity. What are the ID(s) of the flowerbed(s) with the most overfilled capacity?
5. There are 9 flowerbeds that are planted to more than 100% capacity. How many flowerbeds are planted to less than 100% capacity.
6. How many flowerbeds are planted to less than 100% capacity, and have a plant of the type “shrub” planted in them?
7. There are 354 families that are planted in at least one flowerbed in all the parks from the database. How many flowerbeds have at least one plant of all types from the database?



### Database 8 - Songs :

1. How many songs have a duration between 30 minutes and 1 hour (inclusive)?
2. What is the total duration, in seconds, of all explicit songs in the database?
3. The database contains just 5 songs released in 1953. What is the largest number of songs released in a single year?
4. Which year had the largest number of songs?
5. What is the maximum average song duration of an album by Queen?



### Database 9 - Viruses :

1. How many tests have detected the ‘omicron’ variant?
2. How many variants have never been detected with a test?
3. How many different variants of the ‘extreme’ risk level have been detected in 2021 by a tester called ‘Kent Lauridsen’ using a kit produced by ‘JJ’?
4. How many variants cannot be detected by any kit with more than 50% accuracy?
5. What is the lowest average accuracy for any variant which is detected by more than one kit?
6. What is the ID of the tester that has performed the most tests with the kit produced by ‘JJ’?
7. There are 3 testers that have detected all variants with a known risk level. How many testers have detected all variants with risk level ‘mild’?
8. Write a query that returns the timestamp for the last time a detection was made of a variant with risk level ‘extreme’ using a kit that has < 10% accuracy for that variant.














