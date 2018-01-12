#urls for sub emotes use below url with page index at end
base_url = "https://twitchemotes.com/sub/%s"

#iterate over all page indices (hardcoded manually at 699)
#scrape page and extract emote text
full_emote_list = lapply(1:699, function(i) {
  cat("getting emote page", i, "of", 699, "\n")
  html_page = xml2::read_html(sprintf(base_url, i))
  rvest::html_text(rvest::html_nodes(html_page, ".col-md-2 center"))
})
#convert to vec
full_emote_vec = unlist(full_emote_list)

#save to file
writeLines(full_emote_vec, "data/emote_list.txt")
