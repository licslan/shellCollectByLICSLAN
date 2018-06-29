import requests
import json
import urllib.parse
url = 'https://oapi.dingtalk.com/robot/send?access_token=1c10839ec1e14b8ea75c49412c166445d31388e8ac83c866fc4c882557314fe8'
HEADERS = {
"Content-Type": "application/json ;charset=utf-8 "
}
f = open("C:\\Users\\zhangqi\\Desktop\\auto\\svn_log.txt","r")  
lines = f.readlines()#读取全部内容  
String_textMsg = {\
"msgtype": "text",\
"text": {"content": '测试地址：http://192.168.0.91:8080/acme/login.html\n请大家注意本次SVN更新内容：\n%s'%(lines)}}
String_textMsg = json.dumps(String_textMsg)
res = requests.post(url, data=String_textMsg, headers=HEADERS)
print(res.text)
