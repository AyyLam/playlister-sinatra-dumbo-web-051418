class Song < ActiveRecord::Base
  has_many :genres, through: :song_genres
  has_many :song_genres
  belongs_to :artist

  def artist=(artist_name)
    artist = Artist.find_or_create_by(name: artist_name)
    self.artist_id = artist.id
    artist
  end
end
