$passwords='farout','123','Bach','Dragon','Secretshazam','pirateplato','i!h@d@M$!wbr'

$index=1
foreach ($password in $passwords){
    $secure = ConvertTo-SecureString $password -AsPlainText -Force
    New-LocalUser -Name User$index -Password $secure
    $index++
}