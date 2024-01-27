-- (a)
-- In the database, 372 songs have a duration of at most 1 minute. 
SELECT COUNT(*)
  FROM Songs
 WHERE Duration <= interval '1 minute';
-- 372

-- How many songs have a duration between 30 minutes and 1 hour (inclusive)
SELECT COUNT(*)
  FROM Songs
 WHERE Duration >= interval '0.5 hour'
   AND Duration <= interval '1 hour';
-- 6


-- (b)
-- What is the total duration, in seconds, of all explicit songs in the database?
SELECT extract(EPOCH FROM SUM(Duration))
  FROM Songs
 WHERE IsExplicit = 1;
-- 100461


-- (c)
-- The database contains just 5 songs released in 1953. What is the largest number of songs released in a single year?
SELECT MAX(x.cnt)
  FROM (
    SELECT COUNT(*) as cnt
      FROM Songs
     GROUP BY extract(YEAR FROM Releasedate)
  ) x;
-- 833

-- Which year had the largest number of songs?
SELECT extract(YEAR FROM Releasedate) as yr
  FROM Songs
 GROUP BY extract(YEAR FROM Releasedate)
HAVING COUNT(*) = (
    SELECT MAX(x.cnt)
      FROM (
        SELECT extract(YEAR FROM Releasedate) as yr, COUNT(*) as cnt
          FROM Songs
         GROUP BY extract(YEAR FROM Releasedate)
      ) x
    );
-- 2009


-- (d)
-- What is the maximum average song duration of an album by Queen?
SELECT ROUND(extract(EPOCH FROM MAX(x.sd)))
  FROM (
    SELECT als.AlbumId, AVG(s.duration) sd
      FROM Artists a
      JOIN Songs s ON s.ArtistId = a.ArtistId
      JOIN AlbumSongs als ON als.SongId = s.SongId
     WHERE a.Artist = 'Queen'
     GROUP BY als.AlbumId
  ) x;
-- 354

-- What is the maximum average song duration of an album by Daft Punk?
SELECT ROUND(extract(EPOCH FROM MAX(x.sd)))
  FROM (
    SELECT als.AlbumId, AVG(s.duration) sd
      FROM Artists a
      JOIN Songs s ON s.ArtistId = a.ArtistId
      JOIN AlbumSongs als ON als.SongId = s.SongId
     WHERE a.Artist = 'Daft Punk'
     GROUP BY als.AlbumId
  ) x;
-- 370

