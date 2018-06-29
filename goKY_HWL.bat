@echo off
title ACME自动构建工具1.0 by qiweb 20171124
color 0a
set author=https://github.com/QIWEB/BAT_MAVNE_SVN_EMAIL_TOMCAT_AOUT
:::::::::::::: 参数设置::::::::::::::
set svnPan=E:
set dirs=E:\KSFKY
set script_bat=C:\acme_totals
set db_config_dirs=C:\acme_totals\acme_config
set db_config_dirs_xml=C:\acme_totals\acme_config\172_KYxml
rem 邮件设置
set from=xiongwuan@dbgo.cn
set user=xiongwuan@dbgo.cn
set pass=aidsj1314
set to=xiongwuan@dbgo.cn
set subj=ACME自动构建发布成功通知
set mail=%script_bat%\qiweb_auto_log.txt
rem 附件 可以是任何*.jpg *.txt
set attach=%script_bat%\qiweb_auto_log.txt
set server=smtp.qiye.163.com
set debug=-debug -log %script_bat%\blat.log -timestamp

rem 就是blat发邮件工具的目录
set blat_home=%script_bat%

echo %date% %time% 开始任务 自动发布构建> %script_bat%\qiweb_auto_log.txt
SET WORKING_COPY=%dirs%
svn update %WORKING_COPY% 
echo %date% %time%  =================代码svn更新完成 >> %script_bat%\qiweb_auto_log.txt


echo %date% %time%  删除缓存 %dirs%\launch-single\target >> %script_bat%\qiweb_auto_log.txt
rd /s /q %dirs%\launch-single\target

echo %date% %time%  ===============代码maven构建开始 >> %script_bat%\qiweb_auto_log.txt
cd %svnPan%
cd %dirs%
echo  -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
rem svn checkout  https://xxxxx　%dirs% --username　zhangqi --password xxxx

rem mvn clean package  -DskipTests -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
call %dirs%\start_mvn.bat.lnk

echo %date% %time%  ===============代码maven构建完成 >> %script_bat%\qiweb_auto_log.txt




echo 1、设置工作目录：%dirs% >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\static  %dirs%\launch-single\target\acme

echo 2、移动模板 >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\templates %dirs%\launch-single\target\acme\WEB-INF\classes\templates


echo 3、修改日志和全局配置文件 >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs_xml% %dirs%\launch-single\target\acme\WEB-INF\classes
echo 4、手动添加acme-lib下第三方jar >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs%\jar  %dirs%\launch-single\target\acme\WEB-INF\lib
echo 5、重命名原始war包 >> %script_bat%\qiweb_auto_log.txt

ren %dirs%\launch-single\target\acme.war acme_%random%.war
echo 6、生成war包 >> %script_bat%\qiweb_auto_log.txt
cd %dirs%\launch-single\target\acme
%svnPan%

jar cvf acme.war */


echo 7、切换原始工作目录 >> %script_bat%\qiweb_auto_log.txt
cd %svnPan%
cd %script_bat%

echo %date% %time%  备份 acme.war >> %script_bat%\qiweb_auto_log.txt

echo f|xcopy /e /i /y %dirs%\launch-single\target\acme\acme.war  %script_bat%\acme.war



rem -----------------------成功打成war包后往ftp服务器推送--------------------------------------

@echo off
set ftpfile=putfiles.ftp
set logfile=putfiles.log
echo open 11.24.201.36 > "%ftpfile%"
rem 把下面行中的 username和password改为你的用户名和密码
echo user ky_ftp ky >> "%ftpfile%"
rem ------------------------------
echo bin >> "%ftpfile%"
rem 进入FTP server 中的"X"目录
rem echo cd X >> "%ftpfile%" //如果服务器已经对ftp上传文件进行了配置rem echo cd X >> "%ftpfile%" 注释该行
rem ------------------------------
rem 进入本地C盘根目录
echo lcd C:\acme_totals >> "%ftpfile%"
rem ------------------------------再put之前删掉之前的文件  
echo rd acme.war>>"%ftpfile%"
echo put acme.war >> "%ftpfile%"
echo quit >> "%ftpfile%"
echo -------------------------------- >> "%logfile%"
date /t >> "%logfile%"
time /t >> "%logfile%"
echo -------------------------------- >> "%logfile%"
ftp -n < "%ftpfile%" >> "%logfile%"
del "%ftpfile%"
@echo on
rem -----------脚本结束---------------











