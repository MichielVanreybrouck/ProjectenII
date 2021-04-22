$resourceGroup = "mijnResourceGroup"
$location = "westeurope"
$virtualNetworkName = "myVN"
$subnetName = "myIISSubnet"
$vmName = "WinWebServ"
$securityGroup = "mySecuGroup"
$imageName = "MicrosoftSQLServer:SQL2016SP1-WS2016:Enterprise:latest"
$gebruikersnaam = "QuintenDB"
$password = ConvertTo-SecureString "WISAStack123" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($gebruikersnaam, $password) 

New-AzResourceGroup -Name $resourceGroup -Location $location
New-AzVM -ResourceGroupName $resourceGroup `
    -Name $vmName `
    -Location $location `
    -VirtualNetworkname $virtualNetworkName `
    -SubnetName $subnetName `
    -SecurityGroupName $securityGroup `
    -AddressPrefix 192.168.0.0/16 `
    -PublicIpAddressName "myPublicIpAddressName" `
    -OpenPorts 80,3389 -Credential $credential `
    -ImageName $imageName

Set-AzVMSqlServerExtension -ResourceGroupName $resourceGroup -VMName $vmName -Name "SQLExtension" -Location $location 
Set-AzVMExtension `
    -ResourceGroupName $resourceGroup `
    -ExtensionName IIS `
    -VMName $vmName `
    -Publisher Microsoft.Compute `
    -ExtensionType CustomScriptExtension `
    -TypeHandlerVersion 1.4 `
    -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server,Web-Asp-Net45,NET-Framework-Features"}' `
    -Location $location

