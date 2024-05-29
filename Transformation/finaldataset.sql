CREATE OR REPLACE TABLE "new_topics_songs" AS
SELECT 
     t2.*,
    t1."name" as "newtopic",
FROM 
    "topics_songs" t2
LEFT JOIN "topics_words_names" t1  ON  (t1."topic") = (t2."topic")


CREATE or REPLACE TABLE "vystupni_tabulka" AS
select distinct n.*,
t."newtopic" as "topic",
"genre", 
concat('https://open.spotify.com/embed/track/',"id") as "id",
"release_year",
"total_words",
"unique_words"
from "nomineeswinners" as n
left join "spotify" as s on lower(n."song") =  lower(s."song") and  lower(n."artist") = lower(s."artist")
left join "new_topics_songs" as t on lower(n."song") =  lower(t."song") and  lower(n."artist") =lower(t."artist")
left join "filtered_lyrics" as f on lower(n."song") =  lower(f."song") and  lower(n."artist") =lower(f."artist")


CREATE TEMP TABLE "all_topics" AS
SELECT DISTINCT "topic" FROM "vystupni_tabulka";

CREATE TEMP TABLE "all_years" AS
SELECT DISTINCT "daygrammy" FROM "vystupni_tabulka";

CREATE TEMP TABLE "all_winners" AS
SELECT DISTINCT "winner" FROM "vystupni_tabulka";

CREATE TEMP TABLE "all_combinations" AS
SELECT y."daygrammy", t."topic", w."winner"
FROM "all_years" y
CROSS JOIN "all_topics" t
CROSS JOIN "all_winners" w;

CREATE OR REPLACE TABLE "year_topic" AS
SELECT 
    ac."daygrammy",
    ac."topic",
    ac."winner",
    COALESCE(COUNT(vt."song"), 0) AS "song_count"
FROM 
    "all_combinations" ac
LEFT JOIN 
    "vystupni_tabulka" vt 
ON 
    ac."daygrammy" = vt."daygrammy" AND ac."topic" = vt."topic" AND ac."winner" = vt."winner"
GROUP BY 
    ac."daygrammy", ac."topic", ac."winner";