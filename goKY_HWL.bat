@echo off
title ACME�Զ���������1.0 by qiweb 20171124
color 0a
set author=https://github.com/QIWEB/BAT_MAVNE_SVN_EMAIL_TOMCAT_AOUT
:::::::::::::: ��������::::::::::::::
set svnPan=E:
set dirs=E:\KSFKY
set script_bat=C:\acme_totals
set db_config_dirs=C:\acme_totals\acme_config
set db_config_dirs_xml=C:\acme_totals\acme_config\172_KYxml
rem �ʼ�����
set from=xiongwuan@dbgo.cn
set user=xiongwuan@dbgo.cn
set pass=aidsj1314
set to=xiongwuan@dbgo.cn
set subj=ACME�Զ����������ɹ�֪ͨ
set mail=%script_bat%\qiweb_auto_log.txt
rem ���� �������κ�*.jpg *.txt
set attach=%script_bat%\qiweb_auto_log.txt
set server=smtp.qiye.163.com
set debug=-debug -log %script_bat%\blat.log -timestamp

rem ����blat���ʼ����ߵ�Ŀ¼
set blat_home=%script_bat%

echo %date% %time% ��ʼ���� �Զ���������> %script_bat%\qiweb_auto_log.txt
SET WORKING_COPY=%dirs%
svn update %WORKING_COPY% 
echo %date% %time%  =================����svn������� >> %script_bat%\qiweb_auto_log.txt


echo %date% %time%  ɾ������ %dirs%\launch-single\target >> %script_bat%\qiweb_auto_log.txt
rd /s /q %dirs%\launch-single\target

echo %date% %time%  ===============����maven������ʼ >> %script_bat%\qiweb_auto_log.txt
cd %svnPan%
cd %dirs%
echo  -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
rem svn checkout  https://xxxxx��%dirs% --username��zhangqi --password xxxx

rem mvn clean package  -DskipTests -Dmaven.repo.local=D:\idea+maven+jdk+tomcat\maven_repository
call %dirs%\start_mvn.bat.lnk

echo %date% %time%  ===============����maven������� >> %script_bat%\qiweb_auto_log.txt




echo 1�����ù���Ŀ¼��%dirs% >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\static  %dirs%\launch-single\target\acme

echo 2���ƶ�ģ�� >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %dirs%\launch-single\target\acme\templates %dirs%\launch-single\target\acme\WEB-INF\classes\templates


echo 3���޸���־��ȫ�������ļ� >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs_xml% %dirs%\launch-single\target\acme\WEB-INF\classes
echo 4���ֶ����acme-lib�µ�����jar >> %script_bat%\qiweb_auto_log.txt
xcopy /e /i /y %db_config_dirs%\jar  %dirs%\launch-single\target\acme\WEB-INF\lib
echo 5��������ԭʼwar�� >> %script_bat%\qiweb_auto_log.txt

ren %dirs%\launch-single\target\acme.war acme_%random%.war
echo 6������war�� >> %script_bat%\qiweb_auto_log.txt
cd %dirs%\launch-single\target\acme
%svnPan%

jar cvf acme.war */


echo 7���л�ԭʼ����Ŀ¼ >> %script_bat%\qiweb_auto_log.txt
cd %svnPan%
cd %script_bat%

echo %date% %time%  ���� acme.war >> %script_bat%\qiweb_auto_log.txt

echo f|xcopy /e /i /y %dirs%\launch-single\target\acme\acme.war  %script_bat%\acme.war



rem -----------------------�ɹ����war������ftp����������--------------------------------------

@echo off
set ftpfile=putfiles.ftp
set logfile=putfiles.log
echo open 11.24.201.36 > "%ftpfile%"
rem ���������е� username��password��Ϊ����û���������
echo user ky_ftp ky >> "%ftpfile%"
rem ------------------------------
echo bin >> "%ftpfile%"
rem ����FTP server �е�"X"Ŀ¼
rem echo cd X >> "%ftpfile%" //����������Ѿ���ftp�ϴ��ļ�����������rem echo cd X >> "%ftpfile%" ע�͸���
rem ------------------------------
rem ���뱾��C�̸�Ŀ¼
echo lcd C:\acme_totals >> "%ftpfile%"
rem ------------------------------��put֮ǰɾ��֮ǰ���ļ�  
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
rem -----------�ű�����---------------











