atom_feed do |feed|
  feed.title("Match.tf news feed")
  feed.updated(@news[0].created_at) if @news.length > 0

  @news.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.summary(post.shorttext)
      entry.content('<img src="https://match.tf' + post.image.thumb.url + '"><br>' + post.content, type: 'html')
    end
  end
end
