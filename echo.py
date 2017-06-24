#!/usr/bin/env python
# -*- coding: utf-8 -*-

from telegram import (ReplyKeyboardMarkup, ReplyKeyboardRemove)
from telegram.ext import (Updater, CommandHandler, MessageHandler, Filters, RegexHandler,
                          ConversationHandler)
import logging
import time
from callrscript import Predict

# Enable logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)

logger = logging.getLogger(__name__)


# Define a few command handlers. These usually take the two arguments bot and
# update. Error handlers also receive the raised TelegramError object in error.
def start(bot, update):
    update.message.reply_text('您好，歡迎使用公司存活預測系統！')


def help(bot, update):
    update.message.reply_text('請點擊右下角的斜線符號來下指令')

def timee(bot, update):
    currentTime =time.strftime("現在時間：%a, %d %b %Y %H:%M:%S")
    print (currentTime)
    update.message.reply_text(currentTime)

def predict(bot, update):
    update.message.reply_text("請輸入survival 地區(北/中/南/東),資本額,是否股份有限,成立月份") 

def echo(bot, update):
    userstring=update.message.text
    if userstring[0:8]=='survival':
        update.message.reply_text('請稍後計算')
        print(userstring[9:])
        location=userstring[9:].split(',')[0]
        capital=userstring[9:].split(',')[1]
        stock=userstring[9:].split(',')[2]
        start_month=userstring[9:].split(',')[3]
        #print(num,location,capital,stock,start_month)
        if stock==userstring[9:].split(',')[2]=="是":
            stock=1
            pr=Predict()
            update.message.reply_text('您的預測存活天數為%s天'% pr.predict(location,capital,stock,start_month))
        elif stock==userstring[9:].split(',')[2]=="否":
            stock=0
            pr=Predict()
            update.message.reply_text('您的預測存活天數為%s天'% pr.predict(location,capital,stock,start_month))
        else:
            update.message.reply_text("股份有限公司請填是或否")
        
    else:
        update.message.reply_text(update.message.text)
    #print (update.message.text)

def error(bot, update, error):
    logger.warn('Update "%s" caused error "%s"' % (update, error))


def main():
    #currentTime=time.strftime('%a, %d %b %Y %H:%M:%S')
    #print(currentTime)

    # Create the EventHandler and pass it your bot's token.
    updater = Updater("374519570:AAGimr6WVCUH_oHTcv2r-QRp_uxXQSrqGlc")

    # Get the dispatcher to register handlers
    dp = updater.dispatcher

    # on different commands - answer in Telegram
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(CommandHandler("help", help))
    dp.add_handler(CommandHandler("time", timee))
    dp.add_handler(CommandHandler("predict", predict))   

    # on noncommand i.e message - echo the message on Telegram
    dp.add_handler(MessageHandler(Filters.text, echo))

    # log all errors
    dp.add_error_handler(error)

    # Start the Bot
    updater.start_polling()

    # Run the bot until you press Ctrl-C or the process receives SIGINT,
    # SIGTERM or SIGABRT. This should be used most of the time, since
    # start_polling() is non-blocking and will stop the bot gracefully.
    updater.idle()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
print("\nbye bye~\n")
