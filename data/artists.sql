USE harshi_test_db;

DROP TABLE IF EXISTS artists;
CREATE TABLE artists
(
  id              int unsigned NOT NULL auto_increment, # Unique ID for the record
  name            varchar(255) NOT NULL,                # Name of the artist
  age          	  int unsigned NOT NULL,               	# Age of the artist
  totalSongs      int unsigned NOT NULL,               	# Total songs of the artist
  popularSongs    varchar(255),							# popular songs of the artist

  PRIMARY KEY     (id)
);