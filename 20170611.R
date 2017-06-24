company = na.omit(read.csv("C:\\Users\\firerycon\\Desktop\\pythonproject\\20170611try.csv"))
company$days = as.numeric(company$days)
train_idx = sample(1:nrow(company),size = 0.7*nrow(company),replace = F)
com_train = company[train_idx,]
com_test =company[-train_idx,]

#try_test<-data.frame(number=76211194,location="南",capital=50000,stock=0,start_month=8)
#View(try_test)

View(company)

#company_lm = lm(formula = days ~location+capital+stock+start_month,data = com_train,stock=0,)
company_lm = lm(formula = days ~location+capital+stock+start_month,data = com_train)
company_lm

train_pre = predict(company_lm,com_train)
#root mean square error
sqrt((sum((train_pre - com_train$days)^2)) / nrow(com_train))

test_pre = predict(company_lm,com_test)
sqrt((sum((test_pre - com_test$days)^2)) / nrow(com_test))
test_pre

View(cbind(test_pre,com_test$days))

#try_pre = predict(company_lm,try_test)
#try_pre

table(company$location)

#------------------------------------
#rf

company_rf = randomForest::randomForest(formula = days ~location+capital+stock+start_month,data = com_train)
company_rf

train_pre = predict(company_rf,com_train)
#root mean square error
sqrt((sum((train_pre - com_train$days)^2)) / nrow(com_train))

test_pre = predict(company_rf,com_test)
sqrt((sum((test_pre - com_test$days)^2)) / nrow(com_test))
test_pre

View(cbind(test_pre,com_test$days))
readline(prompt="Press [enter] to continue")

