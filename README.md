# NBA Analytics: Player Performance, Era Comparison & MVP Modeling (1996-2022)

## Overview
This project analyzes NBA player performance from 1996–2022 to move beyond subjective basketball debates and ground evaluation in data. Using over **12,000 player-season records across 27 NBA seasons**, the analysis explores how scoring, rebounding, playmaking, efficiency, and team context shape elite performance. It also applies a transparent, weighted performance index to identify MVP-caliber seasons and construct a data-driven all-time starting lineup.

---

## Methodology
- Veteran defined as 4th+ season
- Height-based position mapping: PG ≤188 cm, SG 189–196 cm, SF 197–203 cm, PF 204–210 cm, C ≥211 cm
- MVP index: **30% points, 20% assists, 20% TS%, 15% rebounds, 15% Net-Rating**

--- 

## Exploratory Performance Analysis (EPA)
Exploratory Performance Analysis (EPA) was conducted to understand distributions, outliers, and edge cases before formal modeling.
EPA steps included:
- Generation of descriptive statistics across all numerical features to assess league-wide trends.
- Identification of extreme values in key metrics such as:
  - `net_rating`
  - `ts_pct` (true shooting percentage)
  - `usg_pct` (usage rate)
  - `oreb_pct` and `dreb_pct`
- Manual inspection of players with unusually high efficiency or impact metrics to ensure values reflected realistic playing time and roles.
- Review of edge cases involving players with only 1–2 games played, which informed the minimum games-played filter applied during data cleaning.
- Visualization of games played distribution using histograms with mean and median reference lines to justify filtering thresholds.

These EPA steps ensured that downstream era comparisons, MVP modeling, and team-level insights were built on stable, representative player-season samples.

--
# Data Cleaning & Preparation
The data cleaning process was performed in Google Colab to ensure consistency, reliability, and analytical validity across all player-season records.

Key steps included:
- Initial inspection of the dataset structure, head rows, and column types.
- Identification of missing values, with **1,854 null values in the `college` field**, which was deemed non-essential and removed.
- Removal of non-analytic columns: `college`, `country`, `draft_round`, and `draft_number`.
- Conversion of the `season` column from string format (e.g., `1996-97`) to an integer representing the starting year (e.g., `1996`).
- Standardization of percentage-based metrics (`ts_pct`, `usg_pct`, `oreb_pct`, `dreb_pct`, `ast_pct`) rounded to three decimal places.
- Standardization of physical attributes (`player_height`, `player_weight`) rounded to one decimal place.
- Handling of undrafted players by assigning their rookie season as `draft_year`.
- Calculation of player experience as:  
  **experience = season − draft_year**, followed by removal of the original `draft_year` column.
- Examination of games played (`gp`) distribution and removal of low-participation outliers.
  - Players were filtered to those appearing in **more than the mean number of games (51)**.
  - This step removed **5,570 low-sample player-season records**, reducing noise from short stints and call-ups.
- Final validation using descriptive statistics before exporting the cleaned dataset to CSV.

---

## High-Level Overview of Findings

### 1. Player Performance

#### Scoring Leaders
- **Kevin Durant** is the youngest scoring champion (age 21), while **Michael Jordan** is the oldest (age 35).
- Usage extremes highlight stylistic differences: Durant posted the **lowest usage rate (30.2%)** among scoring champions, while **Russell Westbrook (40.2%)** recorded the highest and remains the only champion with usage above 40%.
- Since **2014**, all scoring champions have averaged **at least 30 PPG**.
- Average scoring champion (1996–present): **30.8 PPG**, **27.4 years old**, **7.1 seasons of experience**, **34.7% usage**, **58.2% true shooting**.

#### Assist Leaders
- **Chris Paul, Steve Nash, and Jason Kidd** dominate assist title counts across the dataset.
- Average assist champion: **10.7 APG**, **45.8% AST%**, **30.3 years old**, and roughly **9 seasons of experience**.
- Notable cases include **LeBron James** as the only non-point guard to win an assist title and **Chris Paul** being both the youngest and oldest assist champion.

#### Rebounding Leaders
- **Dennis Rodman** holds the highest single-season rebounding mark at **16.1 RPG**, with **Kevin Garnett, Dwight Howard, and Andre Drummond** also frequently appearing among rebounding leaders.
- Average rebounding champion: **14.2 RPG**, **12.7% OREB**, **31.1% DREB**, **27.8 years old**, and approximately **7 seasons of experience**.

#### Most Improved & Declines
- Largest single-season improvements include **CJ McCollum (+14 PPG, 2015)**, **Jermaine O’Neal (+6.5 RPG, 2000)**, and **Brevin Knight (+5.4 APG, 2004)**.
- The steepest declines are commonly tied to trades or reduced roles, such as **Isaiah Rider (−11.7 PPG, 2000)**, **Kris Humphries (−5.7 RPG, 2012)**, and **Ty Lawson (−6 APG, 2015)**.

#### Efficiency vs. Usage
- Increased usage does **not consistently reduce efficiency** among elite players. The mean TS% of top-usage players (**56.0%**) slightly exceeds the overall league mean (**53.9%**).
- **Allen Iverson** is the primary outlier, standing as the only top-usage player with TS% below 50%.

---
### 2. ERA & Team Comparisons
- **Los Angeles Lakers (LAL)** lead all teams in top-tier production, with **31 players** finishing top-five primarily in points & rebounds. Scoring dominance is driven primarily by **Kobe Bryant (12)**, **Shaquille O’Neal (5)**, and **LeBron James (2)**, while rebounding excellence is largely concentrated around Shaq.
- **Phoenix Suns (PHX)** excel in playmaking, producing **22 players** top-five finshes perdominantly in assists . The franchise consistently developed elite point guards, led by **Steve Nash (8)**, **Jason Kidd (4)**, and **Chris Paul (3)**.
- **Minnesota Timberwolves (MIN)** stand out in rebounding production outside of LAL, with **12 players** achieving top-five rebounding finishes and **21 in total** largely driven by **Kevin Garnett (7)** and **Kevin Love (3)**.
- **Player size trends by decade** show that athletes in the 2020s are smaller on average (≈2 cm shorter and ~98 kg) than in prior decades. Despite this decline in size, players in the 2020s post higher points, rebounds, and assists per game, reflecting a league-wide shift toward pace, spacing, and skill.

---

### 3. MVP & Dream Team

- Multi-season MVP leaders include **LeBron James (6)**, **Shaquille O’Neal (4)**, and **Giannis Antetokounmpo (3)**.
- Many model-selected MVPs align with official NBA MVP selections, including **Embiid (2022)**, **Giannis (2019)**, **Harden (2017)**, and **Westbrook (2016)**, **Curry (2014,15))**, **Durant (2013)**, **Lebron (2008,09,11,12)**, **Garnett (2003)** and **Shaq (1999)**.
  
- Using height-based position classification and MVP rankings, the data-driven **dream starting five** is:
  - **PG:** Damian Lillard  
  - **SG:** James Harden  
  - **SF:** Kobe Bryant  
  - **PF:** LeBron James  
  - **C:** Giannis Antetokounmpo  

---

## Summary Insight
- **LAL, PHX, and MIN** consistently produce elite performers in scoring, playmaking, and rebounding respectively.
- Modern NBA players are **smaller but more productive**, reflecting strategic and stylistic evolution.
- Elite production follows identifiable patterns in **age, experience, usage, and role stability**.
- Weighted statistical indices can closely approximate MVP outcomes and effectively guide all-time lineup construction.
- **Role changes, trades, and minutes allocation** are major drivers of year-to-year performance volatility.

---

## Notebooks
- `01_data_cleaning_colab.ipynb` — Data cleaning, feature engineering, and exploratory analysis (Google Colab)
- `02_analysis_databricks.sql` — SQL-based analysis and aggregation (Databricks Free Edition)

