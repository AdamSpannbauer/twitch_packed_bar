#download dev version of packed bar plotting library
devtools::install_github("AdamSpannbauer/rPackedBar")

#read function to clean twitch chat log
source("helper_scripts/clean_log_func.R")

#read and clean twitch chat file
agdq_log = irssi_to_df("data/#gamesdonequick.log","2018-01-11")
#tokenize chat messages
tokens = tidytext::unnest_tokens(agdq_log, token, msg, to_lower = FALSE)
#count words
token_counts = tokens[, .N, by=token][order(-N)]

#read in all emotes to join with chat tokens
sub_emotes = readLines("data/emote_list.txt")
glb_emotes = readLines("data/global_emote_list.txt")

#convert emotes to dt for join
sub_emote_dt = data.table::data.table(type="sub", emote_name=sub_emotes)
glb_emote_dt = data.table::data.table(type="global", emote_name=glb_emotes)
emote_dt = rbind(sub_emote_dt, glb_emote_dt)

#join emotes to chat tokens
emote_counts = merge(token_counts, emote_dt, by.x='token', by.y='emote_name')

#plot emotes as packed barchart
set.seed(1337)
p = rPackedBar::plotly_packed_bar(input_data = emote_counts,
                                  label_column = 'token',
                                  value_column = 'N',
                                  number_rows = 4,
                                  plot_title = "AGDQ Secret of Evermore: Emotes in Chat",
                                  xaxis_label = "Emote Count",
                                  hover_label = "N",
                                  min_label_width = .03,
                                  color_bar_color = "#6441A4",
                                  label_color = 'white')
plotly::config(p, displayModeBar = FALSE)
