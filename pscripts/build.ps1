Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Connect-AzAccount -TenantId [-TenantId]
New-AzResourceGroup -Name [-Name] -Location [-Location]




