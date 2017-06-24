#分區方法http://statistic.ngis.org.tw/index.aspx?content=0
company = na.omit(read.csv("C:\\Users\\firerycon\\Desktop\\pythonproject\\20170611try.csv"))
company$days = as.numeric(company$days)
train_idx = sample(1:nrow(company),size = 1*nrow(company),replace = F)
com_train = company[train_idx,]

features=read.csv("C:\\Users\\firerycon\\Desktop\\pythonproject\\features.csv")
try_test<-data.frame(location=features$location,capital=features$capital,stock=features$stock,start_month=features$start_month)

#company_lm = lm(formula = days ~location+capital+stock+start_month,data = com_train,stock=0,)
company_lm = lm(formula = days ~location+capital+stock+start_month,data = com_train)
company_lm

train_pre = predict(company_lm,com_train)
#root mean square error
sqrt((sum((train_pre - com_train$days)^2)) / nrow(com_train))

try_pre = predict(company_lm,try_test)
try_pre
try_pre[1]

write(try_pre, "C:\\Users\\firerycon\\Desktop\\pythonproject\\mydata.txt", sep="\t")

