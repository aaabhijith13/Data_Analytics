#Final project code,  Abhijith ANil Vamadev IST 719
library(ggplot2)
library(tidyverse)
library(treemap)
library(dplyr)
  #How has the gaming scene of twitch changed from 2016 to 2021? 
# 5 plots in total - 2 distributon plots, 2 bivariate plot, 1 main plot
#Main plot showing top 5 games of each year since 2016 to 2021, bar graph
#Distribution plot 1  - Hours watched 
data <- read.csv("C:\\Users\\Abhijith A V\\Desktop\\IST_719\\final_project\\Twitch_game_data.csv")
head(data)
colnames(data)


df <- data %>% mutate_at("Hours_Streamed", str_replace, "hours", "")
head(df)
str(df)
df$Hours_Streamed <- as.numeric(df$Hours_Streamed)

df$Hours_Streamed
lapply(df,function(x) { length(which(is.na(x)))}) #no null values


#The data shows how gaming trends changes throughout the years. Gaming has become more popular over the years, allowing streaming platforms like Twitch to beocome popular, especially during the pandemic. By comparing their total number of views by year, they are ranked from most popular to least popular video games by year. 




ss <- aggregate(Hours_watched~Year + Game, df, sum)
new_agg <- aggregate(Avg_channels~Year, df, sum)
new_agg
new <- ss[order(ss$Hours_watched, decreasing = TRUE),]
new_stuff <- new[order(new$Year, decreasing = TRUE),]
y2021<- head(new_stuff[new_stuff$Year == '2021',],2)
y2020<- head(new_stuff[new_stuff$Year == '2020',],2)
y2019<- head(new_stuff[new_stuff$Year == '2019',],2)
y2018<- head(new_stuff[new_stuff$Year == '2018',],2)
y2017<- head(new_stuff[new_stuff$Year == '2017',],2)
y2016<- head(new_stuff[new_stuff$Year == '2016',],2)

final_df_10 <- bind_rows(y2021, y2020, y2019, y2018, y2017, y2016)
final_df_10
#final_df_10$Year <- factor(final_df_10$Year, labels=c("2021", "2020", "2019", "2018", "2017", "2016"))
final_df_10
countt <- final_df_10 %>% count(Game)
countt
list_games = final_df_10$Game
list <- unique(list_games)
list
new_data <-  subset(df, Game %in% list)
new_data
order(final_df_10, final_df_10$Year)
head(df)
#Main plot
g1 <- ggplot(final_df_10, aes(y =  Hours_watched, x = desc(Year), fill = Game)) +
  geom_bar(stat = 'identity', position=position_dodge(), width = 0.7) + theme_minimal() + 
  scale_color_manual(values = c('#7fc97f', '#beaed4', '#fdc086', '#386cb0', '#ffff99', '#f0027f'))+
  xlab('Year') + ylab('Numbers of Hours_watched') +labs(title = "Top 2 Popular games by year, from 2016 to 2021")+ theme_classic()
g1
#Distribution plot
g2 <- ggplot(final_df_10, aes(Game)) +
  geom_bar(fill = "#0073C2FF") + xlab('Game') + ylab('Count') +labs(title = 'Count of Popular Games') + coord_flip() + theme_classic()
g2

g4 <- ggplot(df, aes(x=Avg_viewers, y=Hours_watched)) + 
  geom_point(color = 'black', size = 1.5) + 
  geom_smooth(method="auto", se=TRUE, fullrange=FALSE, level=0.95) + 
  ylim(c(0, 3e+08)) + xlim(c(0, 4.1e+05)) + 
  labs(title = 'Hours Watched vs Average Numer of Viewers') + geom_vline(xintercept=mean(df$Avg_viewers),linetype=2) + geom_hline(yintercept=mean(df$Hours_watched),linetype=2)
  xlab('Average number of viewers') + ylab('Numbers of Hours watched') + theme_classic()
g4

g3 <- ggplot(data = new_data)+ 
  geom_col(aes(x = Year, y = Avg_viewers, color = 'black', fill = 'white')) + 
  labs(title = 'Average Vieweship by Year from 2016 to 2021') + 
  ylab('Average number of viewers per stream (Millions)') + theme_classic()
g3
G5<-aggregate(new_data, list(new_data$Game), FUN=length)
treemap(G5,
        index="Group.1",
        vSize="Hours_watched",
        type="index",
        title="Top 2 popular games from 2016 to 2021",
        fontsize.title = 18,
        fontsize.labels = 18
)
df$Avg_viewers
str(unique(df$Game))
unique(df$Game)
