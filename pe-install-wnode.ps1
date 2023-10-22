<powershell>
New-Item \Users\Administrator\Desktop\start.txt  -ItemType file
[System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('https://${master_private_dns}:8140/packages/current/install.ps1', 'install.ps1'); .\install.ps1 -v
New-Item \Users\Administrator\Desktop\end.txt  -ItemType file
</powershell>
