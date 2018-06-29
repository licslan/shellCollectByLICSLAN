rem -----------------------成功打成war包后往ftp服务器推送--------------------------------------

@echo off
set ftpfile=putfiles.ftp
set logfile=putfiles.log
echo open 11.24.201.36 > "%ftpfile%"
rem 把下面行中的 username和password改为你的用户名和密码
echo user bytest_ftp by_test >> "%ftpfile%"
rem ------------------------------
echo bin >> "%ftpfile%"
rem 进入FTP server 中的"X"目录
rem echo cd X >> "%ftpfile%" //如果服务器已经对ftp上传文件进行了配置rem echo cd X >> "%ftpfile%" 注释该行
rem ------------------------------
rem 进入本地C盘根目录
echo lcd C:\acme_totals >> "%ftpfile%"
rem ------------------------------再put之前删掉之前的文件  
echo rd xxx.txt>>"%ftpfile%"
echo put xxx.txt>> "%ftpfile%"
echo quit >> "%ftpfile%"
echo -------------------------------- >> "%logfile%"
date /t >> "%logfile%"
time /t >> "%logfile%"
echo -------------------------------- >> "%logfile%"
ftp -n < "%ftpfile%" >> "%logfile%"
del "%ftpfile%"
@echo on
rem -----------脚本结束---------------