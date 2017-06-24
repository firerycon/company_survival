library(dplyr)                
library(magrittr)   
library(lubridate)
library(randomForest)
options(scipen=999)
data_year <- c(2013:2017) %>% as.character()
data_month <- c("01","02","03",'04','05','06','07','08','09','10','11','12')

total_data <- data.frame()
for (i in 1:length(data_year)){
  if (data_year[i]=="2013"){
    data_month_j <- data_month[2:12] 
  }else if (data_year[i]=="2017"){
    data_month_j <- data_month[1:4]
  }else{
    data_month_j <- data_month
  }
  for (j in 1:length(data_month_j)){
    data <- read.csv(file=paste0("D:/big_data/",data_year[i],data_month_j[j],".csv"))
    data <- data[,c(2,3,4,6,7,8)]
    colnames(data) <- c("number","company","location","capital","start","end")
    total_data <- rbind(total_data,data)
    cat(paste0("process:",j,"/",i),"\n")
  }
}
total_data <- total_data %>% filter(capital!=0)
total_data$start <- total_data$start+19110000 
total_data$end <- total_data$end+19110000
total_data$start <- as.Date(as.character(total_data$start),"%Y%m%d")
total_data$end <- as.Date(as.character(total_data$end),"%Y%m%d")
total_data$survival <- as.numeric(total_data$end-total_data$start)
total_data$survival_years <- total_data$survival/360
total_data <- na.omit(total_data)
summary(total_data$survival_years) 
company_type <- data.frame()
area_type <- data.frame()
survival_type <- data.frame()
for (i in 1:nrow(total_data)){
  type <- ifelse(sum(grep("股份有限公司",total_data$company[i]))==1,1,0)
  if (sum(grep("臺北市",total_data$location[i]))==1){
    area <- "臺北市"
  }
  else if (sum(grep("臺北縣",total_data$location[i]))==1){
    area <- "臺北縣"
  }
  else if (sum(grep("新北市",total_data$location[i]))==1){
    area <- "新北市"
  }
  else if (sum(grep("桃園市",total_data$location[i]))==1){
    area <- "桃園市"
  }
  else if (sum(grep("桃園縣",total_data$location[i]))==1){
    area <- "桃園縣"
  }
  else if (sum(grep("新竹縣",total_data$location[i]))==1){
    area <- "新竹縣"
  }
  else if (sum(grep("新竹市",total_data$location[i]))==1){
    area <- "新竹市"
  }
  else if (sum(grep("宜蘭縣",total_data$location[i]))==1){
    area <- "宜蘭縣"
  }
  else if (sum(grep("基隆市",total_data$location[i]))==1){
    area <- "基隆市"
  }
  else if (sum(grep("苗栗縣",total_data$location[i]))==1){
    area <- "苗栗縣"
  }
  else if (sum(grep("臺中縣",total_data$location[i]))==1){
    area <- "臺中縣"
  }
  else if (sum(grep("臺中市",total_data$location[i]))==1){
    area <- "臺中市"
  }
  else if (sum(grep("彰化縣",total_data$location[i]))==1){
    area <- "彰化縣"
  }
  else if (sum(grep("雲林縣",total_data$location[i]))==1){
    area <- "雲林縣"
  }
  else if (sum(grep("南投縣",total_data$location[i]))==1){
    area <- "南投縣"
  }
  else if (sum(grep("嘉義縣",total_data$location[i]))==1){
    area <- "嘉義縣"
  }
  else if (sum(grep("嘉義市",total_data$location[i]))==1){
    area <- "嘉義市"
  }
  else if (sum(grep("臺南縣",total_data$location[i]))==1){
    area <- "臺南縣"
  }
  else if (sum(grep("臺南市",total_data$location[i]))==1){
    area <- "臺南市"
  }
  else if (sum(grep("高雄縣",total_data$location[i]))==1){
    area <- "高雄縣"
  }
  else if (sum(grep("高雄市",total_data$location[i]))==1){
    area <- "高雄市"
  }
  else if (sum(grep("屏東縣",total_data$location[i]))==1){
    area <- "屏東縣"
  }
  else if (sum(grep("花蓮縣",total_data$location[i]))==1){
    area <- "花蓮縣"
  }
  else if (sum(grep("臺東縣",total_data$location[i]))==1){
    area <- "臺東縣"
  }
  else{
    area <- "其他"
  }
  if (total_data$survival_years[i]<1){
    level <- "E"
  }
  else if (total_data$survival_years[i]>=1&total_data$survival_years[i]<5){
    level <- "D"
  }
  else if (total_data$survival_years[i]>=5&total_data$survival_years[i]<10){
    level <- "C"
  }
  else if (total_data$survival_years[i]>=10&total_data$survival_years[i]<20){
    level <- "B"
  }
  else if (total_data$survival_years[i]>=20){
    level <- "A"
  }
  company_type <- rbind(company_type,type)
  area_type <- rbind(area_type,area,stringsAsFactors =FALSE)
  survival_type <- rbind(survival_type,level,stringsAsFactors =FALSE)
  cat(paste0("process:",i,"/",nrow(total_data)),"\n")
}
total_data$stock_type <- company_type[1:nrow(company_type),1]
total_data$location <- area_type[1:nrow(area_type),1]
total_data$survival_level <- survival_type[1:nrow(survival_type),1]
total_data <- total_data %>% select(number,capital,start,end,stock_type,location,survival_level) %>%
              mutate(start_mon=months(total_data$start),
                     end_mon=months(total_data$end))

total_data$survival_level <- as.factor(total_data$survival_level)
total_data$stock_type <- as.factor(total_data$stock_type)
total_data$location <- as.factor(total_data$location)
total_data$start_mon <- as.factor(total_data$start_mon)
total_data$end_mon <- as.factor(total_data$end_mon)

signal_data <- read.csv("D:/big_data/current_signal.csv")
colnames(signal_data) <- c("date","score")
signal_data$date <- as.Date(as.character(signal_data$date))
total_data_v2 <- total_data %>% filter(start>=as.Date("1984-01-01"))
score_list <- data.frame()
for (k in 1:nrow(total_data_v2)){
  M <- signal_data %>% filter(year(date)==year(total_data_v2$start[k])&months(date)==months(total_data_v2$start[k]))
  M_score <- M$score[1]
  score_list <- rbind(score_list,M_score)
  cat(paste0("process:",k,"/",nrow(total_data_v2)),"\n")
}
total_data_v2$score <- as.factor(score_list[1:nrow(score_list),1])
total_data_v3 <- total_data_v2 %>% filter(capital<=800000)
#--------------建立模型-------------------------------
train_ind <- sample(1:nrow(total_data),ceiling(0.7*nrow(total_data_v3)))
train_data <- total_data_v3[train_ind,] %>% na.omit()
test_data <- total_data_v3[-train_ind,]

survival_model <- randomForest(formula=survival_level~location+capital+score+stock_type,data=train_data,ntree=1000)
print(survival_model)


result <- predict(survival_model,train_data)
conf_matrix <- table(result,train_data$survival_level)
#準確率
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
accuracy


#-------分析--------------------
start_data <- total_data %>% filter(start>=as.Date("2013-02-01"))
shut_down_2013 <- total_data %>% filter(as.numeric(year(end))==2013)
shut_down_2014 <- start_data %>% filter(as.numeric(year(end))==2014)
shut_down_2015 <- start_data %>% filter(as.numeric(year(end))==2015)
shut_down_2016 <- start_data %>% filter(as.numeric(year(end))==2016)
shut_down_2017 <- start_data %>% filter(as.numeric(year(end))==2017)
#2013
total_start_2013 <- read.csv("D:/big_data/company_2013.csv") 
total_start_2013 <- total_start_2013[,c(2,4,6,8,9)]
colnames(total_start_2013) <- c("number","stock_type","location","capital","start")
total_start_2013 <- total_start_2013 %>% filter(capital!=0)
total_start_2013$start <- as.character(total_start_2013$start) %>% as.numeric()
total_start_2013 <- na.omit(total_start_2013)
total_start_2013$start <- total_start_2013$start+19110000 
total_start_2013$start <- as.Date(as.character(total_start_2013$start),"%Y%m%d")
total_start_2013$start_mon <- months(total_start_2013$start)
#2014
total_start_2014 <- read.csv("D:/big_data/company_2014.csv") 
total_start_2014 <- total_start_2014[,c(2,4,6,8,9)]
colnames(total_start_2014) <- c("number","stock_type","location","capital","start")
total_start_2014 <- total_start_2014 %>% filter(capital!=0)
total_start_2014$start <- as.character(total_start_2014$start) %>% as.numeric()
total_start_2014 <- na.omit(total_start_2014)
total_start_2014$start <- total_start_2014$start+19110000 
total_start_2014$start <- as.Date(as.character(total_start_2014$start),"%Y%m%d")
total_start_2014$start_mon <- months(total_start_2014$start)
#2015
total_start_2015 <- read.csv("D:/big_data/company_2015.csv") 
total_start_2015 <- total_start_2015[,c(2,4,6,8,9)]
colnames(total_start_2015) <- c("number","stock_type","location","capital","start")
total_start_2015 <- total_start_2015 %>% filter(capital!=0)
total_start_2015$start <- as.character(total_start_2015$start) %>% as.numeric()
total_start_2015 <- na.omit(total_start_2015)
total_start_2015$start <- total_start_2015$start+19110000 
total_start_2015$start <- as.Date(as.character(total_start_2015$start),"%Y%m%d")
total_start_2015$start_mon <- months(total_start_2015$start)
#2016
total_start_2016 <- read.csv("D:/big_data/company_2016.csv") 
total_start_2016 <- total_start_2016[,c(2,4,6,8,9)]
colnames(total_start_2016) <- c("number","stock_type","location","capital","start")
total_start_2016 <- total_start_2016 %>% filter(capital!=0)
total_start_2016$start <- as.character(total_start_2016$start) %>% as.numeric()
total_start_2016 <- na.omit(total_start_2016)
total_start_2016$start <- total_start_2016$start+19110000 
total_start_2016$start <- as.Date(as.character(total_start_2016$start),"%Y%m%d")
total_start_2016$start_mon <- months(total_start_2016$start)
#2017
total_start_2017 <- read.csv("D:/big_data/company_2017.csv") 
total_start_2017 <- total_start_2017[,c(2,4,6,8,9)]
colnames(total_start_2017) <- c("number","stock_type","location","capital","start")
total_start_2017 <- total_start_2017 %>% filter(capital!=0)
total_start_2017$start <- as.character(total_start_2017$start) %>% as.numeric()
total_start_2017 <- na.omit(total_start_2017)
total_start_2017$start <- total_start_2017$start+19110000 
total_start_2017$start <- as.Date(as.character(total_start_2017$start),"%Y%m%d")
total_start_2017$start_mon <- months(total_start_2017$start)
total_start_2017 <- total_start_2017 %>% filter(start<as.Date("2017-05-01"))
#----------總設立--------
total_startup <- rbind(total_start_2013,total_start_2014,total_start_2015,total_start_2016,total_start_2017) %>% na.omit()
total_startup$start_mon <- as.factor(total_startup$start_mon)
total_startup$location <- as.factor(total_startup$location)
total_survival_rate <- 1-nrow(start_data)/(nrow(total_start_2013)+nrow(total_start_2014)+nrow(total_start_2015)+nrow(total_start_2016)+nrow(total_start_2017))
start_data$days <- as.Date(start_data$end)-as.Date(start_data$start)
hist(as.numeric(start_data$days))
a <- summary(total_startup$start_mon) %>% as.data.frame()
colnames(a) <- "month_start"
b <- summary(start_data$end_mon) %>% as.data.frame()
colnames(b) <- "month_end"
c <- summary(shut_down_2013$end_mon)%>% as.data.frame()
length()
