rem -----------------------�ɹ����war������ftp����������--------------------------------------

@echo off
set ftpfile=putfiles.ftp
set logfile=putfiles.log
echo open 11.24.201.36 > "%ftpfile%"
rem ���������е� username��password��Ϊ����û���������
echo user bytest_ftp by_test >> "%ftpfile%"
rem ------------------------------
echo bin >> "%ftpfile%"
rem ����FTP server �е�"X"Ŀ¼
rem echo cd X >> "%ftpfile%" //����������Ѿ���ftp�ϴ��ļ�����������rem echo cd X >> "%ftpfile%" ע�͸���
rem ------------------------------
rem ���뱾��C�̸�Ŀ¼
echo lcd C:\acme_totals >> "%ftpfile%"
rem ------------------------------��put֮ǰɾ��֮ǰ���ļ�  
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
rem -----------�ű�����---------------