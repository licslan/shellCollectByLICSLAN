#!/bin/bash
# author:hwl
# this is test for geting datas from server
# 获取本机IP地址
ipaddr=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -d '/' -f1)
echo "  <-----------------ip address is ---------------->  "$ipaddr
# 服务默认状态未启动
status=0
# 请求接口的地址
url="192.168.0.5:8080/process/getDatas"

# 请求接口的地址  更新状态 停止和启动
urlSuccess="192.168.0.5:8080/process/updateMessage"
# 轮询服务端 获取返回的IP地址和本机IP地址匹配 以及对服务器要进行的操作（重启还是停止）
#curl -i -X POST -H "'Content-type':'application/json'" -d '{"ATime":"'$atime'","BTime":"'$btime'"}' $url
result=$(curl -d "ipaddr=$ipaddr" $url)

echo "gg----------------------------------------hh------------------------"$result

# 定义服务名称
tomcat_name="tomcat"

zookeeper_name="zookeeper"

mongodb_name="mongodb"

nginx_name="nginx"

redis_name="redis"

vertx_name="vertx"

mysql_name="mysql"

# 定义一个装服务名称的数组
array_service_name[0]=$tomcat_name
array_service_name[1]=$zookeeper_name
array_service_name[2]=$mongodb_name
array_service_name[3]=$nginx_name
array_service_name[4]=$redis_name
array_service_name[5]=$vertx_name
array_service_name[6]=$mysql_name




# 获取json对象属性
#test=jq '.nginx' $result
#test=$result | jq '.redis'
echo $result > json.json
# 获取redis服务
redis_status=$(cat json.json | jq '.redis')
echo $redis_status

# 获取tomcat服务
tomcat_status=$(cat json.json | jq '.tomcat')
echo $tomcat_status

# 获取nginx服务
nginx_status=$(cat json.json | jq '.nginx')
echo $nginx_status

# 获取mongodb服务
mongodb_status=$(cat json.json | jq '.mongodb')
echo $mongodb_status

# 获取zookeeper服务
zookeeper_status=$(cat json.json | jq '.zookeeper')
echo $zookeeper_status

# 获取vertx服务
vertx_status=$(cat json.json | jq '.vertx')
echo $vertx_status

# 获取mysql服务
mysql_status=$(cat json.json | jq '.mysql')
echo $mysql_status


# 定义一个数组 将解析好的状态内容放入到数组中
status_array=()

for name in ${array_service_name[@]}  
do  
    echo cat json.json | jq '.${name}'  
done

echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"


exit



echo "暂停10秒--"
sleep 2s
echo "暂停结束--"



#  定义状态码  3-----正在启动中     4------正在停止中
starting=3
stoping=4
echo $starting
echo $stoping
echo $tomcat_status
echo $tomcat_status | cut -d '"' -f2

echo $tomcat_status| cut -d '"' -f2  > aaa.txt

#echo 12 > aaa.txt


xx=$(cat aaa.txt) 
echo $xx
echo "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
# 获取tomcat服务
echo "------------进入tomcat服务操作项start-------------------"


pid_tomcats=$(ps -ef|grep tomcat|grep -v grep|awk '{print$2}')
echo "[tomcat进程id]  "$pid_tomcats
	#说明服务运行中
 if  [ $pid_tomcats ];
    then
		 # 如果==4 就需要停止服务
		 if [ $xx = $b ];
		 	then
		 	    kill -9 $pid_tomcats  
		 	    echo "tomcat服务停止"
		 	    # 停顿5秒钟
				sleep 5s
		 	    # 停止后 并向远程服务器发送请求 告知服务器服务停止成功
		 	    curl -d "ipaddr=$ipaddr&name=$tomcat_name&status=2" $urlSuccess
		 else
   				echo "没有符合的条件--------------"
		 fi	    
    else 
		   #如果==3 就需要启动服务
		   if [ $xx = $a ];
		 	then
		 	    # 启动服务
		 	    echo "tomcat服务启动中"
		 	    cd /tools/tomcat/apache-tomcat-8.5.29/bin
		 	    # cd /acme_dbgo/tomcat8/apache-tomcat-8.5.29/bin/
				./startup.sh
				# 停顿5秒钟
				sleep 5s
				curl -d "ipaddr=$ipaddr&name=$tomcat_name&status=1" $urlSuccess
		  else
             echo "没有符合的条件"
          fi
 fi

 echo "------------进入tomcat服务操作项start-------------------"


# 获取redis服务
echo "------------进入redis服务操作项start-------------------"


num_redis=0
pid_rediss=$(ps -ef|grep redis|grep -v grep|awk '{print$2}')
echo "[redis进程id]  "$pid_rediss
#  当进程id有多个时候的需要循环遍历  遍历kill  进程
for pid_redis in $pid_rediss
do
 if test $[pid_redis] -gt $[num_redis]
    then
    # kill -9 $pid_redis echo "redis服务停止"
	# if redis server is running so you can send message to romete server
	echo "---------------------redis 服务运行中-------------------------"
	# to do something .....
	sleep 2s
 else 
	echo "redis 服务未启动或者没有该服务。。。"
	# to do something ....
 fi
done

echo "------------完成redis服务操作项end-------------------"


# # 获取mongodb服务
# num_mongodb=0
# pid_mongodbs=$(ps -ef|grep mongodb|grep -v grep|awk '{print$2}')
# echo "mongodb进程id  "$pid_mongodbs
# #  当进程id有多个时候的需要循环遍历  遍历kill  进程
# for pid_mongodb in $pid_mongodbs
# do
#  if test $[pid_mongodb] -gt $[num_mongodb]
#     then
#          #kill -9 $pid_mongodb echo "mongodb服务停止"
#          # kill -9 $pid_redis echo "redis服务停止"
# 		 # if redis server is running so you can send message to romete server
# 		 echo "---------------------mongodb 服务运行中-------------------------"


# 	# to do something .....
# 	sleep 2s
#     else 
#     	 #echo "mongodb服务未启动。。。"
#     	 echo "mongodb 服务未启动或者没有该服务。。。"
#     	 # to do something ....
#  fi
# done





# # 获取nginx服务
# num_nginx=0
# pid_nginxs=$(ps -ef|grep nginx|grep -v grep|awk '{print$2}')
# echo "nginx进程id  "$pid_nginxs
# #  当进程id有多个时候的需要循环遍历  遍历kill  进程
# for pid_nginx in $pid_nginxs
# do
#  if test $[pid_nginx] -gt $[num_nginx]
#     then
#          #kill -9 $pid_nginx echo "nginx服务停止"
#          # kill -9 $pid_nginx echo "nginx服务停止"
# 		 # if redis server is running so you can send message to romete server
# 		 echo "---------------------nginx 服务运行中-------------------------"
# 	# to do something .....
# 	sleep 1s
#     else 
#     	 #echo "nginx服务未启动。。。"
#     	 echo "nginx 服务未启动或者没有该服务。。。"
#     	 # to do something ....
#  fi
# done









#可参照：http://www.voidcn.com/blog/Vindra/article/p-4917667.html
#一、get请求 
#curl "http://www.baidu.com"  如果这里的URL指向的是一个文件或者一幅图都可以直接下载到本地
#curl -i "http://www.baidu.com"  显示全部信息
#curl -l "http://www.baidu.com" 只显示头部信息
#curl -v "http://www.baidu.com" 显示get请求全过程解析
#wget "http://www.baidu.com"也可以
#二、post请求
#curl -d "param1=value1&param2=value2" "http://www.baidu.com"
#三、json格式的post请求
#curl -l -H "Content-type: application/json" -X POST -d '{"phone":"13521389587","password":"test"}' http://domain/apis/users.json
#例如：
#curl -l -H "Content-type: application/json" -X POST -d '{"ver": "1.0","soa":{"req":"123"},"iface":"me.ele.lpdinfra.prediction.service.PredictionService","method":"restaurant_make_order_time","args":{"arg2":"\"stable\"","arg1":"{\"code\":[\"WIND\"],\"temperature\":11.11}","arg0":"{\"tracking_id\":\"100000000331770936\",\"eleme_order_id\":\"100000000331770936\",\"platform_id\":\"4\",\"restaurant_id\":\"482571\",\"dish_num\":1,\"dish_info\":[{\"entity_id\":142547763,\"quantity\":1,\"category_id\":1,\"dish_name\":\"[0xe7][0x89][0xb9][0xe4][0xbb][0xb7][0xe8][0x85][0x8a][0xe5][0x91][0xb3][0xe5][0x8f][0x89][0xe7][0x83][0xa7][0xe5][0x8f][0x8c][0xe6][0x8b][0xbc][0xe7][0x85][0xb2][0xe4][0xbb][0x94][0xe9][0xa5][0xad]\",\"price\":31.0}],\"merchant_location\":{\"longitude\":\"121.47831425\",\"latitude\":\"31.27576153\"},\"customer_location\":{\"longitude\":\"121.47831425\",\"latitude\":\"31.27576153\"},\"created_at\":1477896550,\"confirmed_at\":1477896550,\"dishes_total_price\":0.0,\"food_boxes_total_price\":2.0,\"delivery_total_price\":2.0,\"pay_amount\":35.0,\"city_id\":\"1\"}"}}' http://vpcb-lpdinfra-stream-1.vm.elenet.me:8989/rpc
#ps：json串内层参数需要格式化
# 打印最后一行  sed -n '$p' txt.txt|awk '{print $0}'
# 打印第一行    sed -n '1p' txt.txt|awk '{print $0}'
# 打印IP信息    echo $(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')








