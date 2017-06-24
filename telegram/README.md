<b> echo.py </b>

echo.py is the main file in this chatbot.</br> The basic function in this file is echo what user say in the dialog box.</br>
There are few exceptions here.
1. /start: chat bot will echo '您好，歡迎使用公司存活預測系統！' to user.
2. /help: chat bot will echo '請點擊右下角的斜線符號來下指令' to user.
3. /time: chat bot will echo current time to user.
4. /predict: chat bot will echo "請輸入survival 地區(北/中/南/東),資本額,是否股份有限,成立月份" to user.
5. "survival" with correct parameter after: echo.py will call callrscript.py to run the predict code and give the result to user.
6. "survival" with wrong parameter after: echo.py will repeat what user said.
7. "survival" with correct parameter after and only type wrong stack parameter: echo.py will echo "股份有限公司請填是或否"
