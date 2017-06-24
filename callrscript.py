#-*-coding:utf-8-*-
import time
import subprocess as sub

class Predict:
	def __init__(self):
		pass

	def predict(self,location,capital,stock,start_month):
            file = open('features.csv','w')
            file.write("location,capital,stock,start_month\n")
            file.write("{0},{1},{2},{3}\n".format(location,capital,stock,start_month))
            file.close()


            sub.Popen([r"C:/Program Files/R/R-3.3.3/bin/Rscript","C:/Users/Firerycon/Desktop/pythonproject/20170612.R"])

            time.sleep(3)

            file = open('mydata.txt')
            #print(file.read())
            survival=file.read()
            print (survival)
            file.close()

            return survival
