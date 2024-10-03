DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes FLOAT,
    comments FLOAT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream FLOAT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA 
select * from spotify

select count(*) as total_count from spotify

select count(distinct artist) as artist_list from spotify  

select distinct album_type,count(*) as total_count  from spotify  
group by album_type

select distinct duration_min,count(*) from spotify
group by duration_min

select  max(duration_min) from spotify

select min(duration_min) from spotify

select * from spotify where duration_min = 0 

-- need to delete the index with the null values
delete from spotify where duration_min = 0 

select most_played_on,count(*) as most_played from spotify
group by most_played_on


                 --Easy Level

-- 1.)Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify where stream>1000000000

--2.) List all albums along with their respective artists.

select distinct artist,album from spotify
group by 1,2

--3.)Get the total number of comments for tracks where licensed = TRUE.
select * from spotify
select sum(comments)as sum_of_comments, from spotify where licensed = 'true'

--4.)Find all tracks that belong to the album_type single.
select track,album_type from spotify where album_type = 'single'
group by 1,2

--5.)Count the total number of tracks by each artist.
select artist,count(*) as total_no_songs from spotify
group by 1
order by 2 
 
              --medium level

--1.)Calculate the average danceability of tracks in each album.
select distinct album,avg(danceability) as avg_danceability from spotify
group by 1
order by 2 desc

--2.)Find the top 5 tracks with the highest energy values.
select track,max(energy) as max_energy_tracks from spotify
group by 1
order by 2 desc
limit 5

--3.)List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views) as total_views ,sum(likes) as sum_of_likes from spotify
where official_video = 'TRUE'
group by 1
order by 2 desc
limit 5

--4.)For each album, calculate the total views of all associated tracks.
select  distinct album,track,sum(views) as total_views from spotify
group by 1,2
order by 3 desc

--5.)Retrieve the track names that have been streamed on Spotify more than YouTube.
--select * from spotify
select * from (select track,
coalesce(sum(case when most_played_on='Youtube' then stream end),0) as streamed_on_youtube,
coalesce(sum(case when most_played_on='Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1 ) as t1
where streamed_on_youtube<streamed_on_spotify
and streamed_on_youtube <> 0

                      --Advanced Level


--1.)Find the top 3 most-viewed tracks for each artist using window functions.

--select * from spotify
with ranking_artist as (
select artist,track,sum(views) as total_views,
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1,2
order by 1,3 desc
)
select * from ranking_artist
where rank <=3


--2)Write a query to find tracks where the liveness score is above the average.
select * from spotify

SELECT track,artist,liveness
FROM spotify 
WHERE liveness <= (SELECT avg(liveness) FROM spotify)

--3.)Use a WITH clause to calculate the difference between the
--highest and lowest energy values for tracks in each album.

select * from spotify

Explain analyze
with cte as (
select album,
max(energy) as maximum_energy,
min(energy) as minimum_energy from spotify
group by 1
)

select album,maximum_energy - minimum_energy as difference_between_energy from cte
order by cte asc



































