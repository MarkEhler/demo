[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
$env:DD_API_KEY = '6f5d0ed636e7f1129d4c6aa388f00bff';
$env:DD_SITE = 'us5.datadoghq.com';
(New-Object System.Net.WebClient).DownloadFile('https://install.datadoghq.com/datadog-installer-x86_64.exe', 'C:\Windows\SystemTemp\datadog-installer-x86_64.exe');
C:\Windows\SystemTemp\datadog-installer-x86_64.exe