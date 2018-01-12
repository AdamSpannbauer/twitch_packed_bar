#all global emotes on this page
base_url = "https://twitchemotes.com"

#scrape all emote text
html_page = xml2::read_html(base_url)
full_emote_vec = rvest::html_text(rvest::html_nodes(html_page, "center"))

#save to file
writeLines(full_emote_vec, "data/global_emote_list.txt")
