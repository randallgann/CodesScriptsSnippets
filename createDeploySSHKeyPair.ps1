param(
    [string]$serverIpAddress,
    [string]$passphrase
)

# Generate a new SSH key pair with a passphrase
$filename = "id_rsa_$($serverIpAddress -replace "\.", "_")"
$sshPath = "$env:USERPROFILE\.ssh"
if (!(Test-Path $sshPath)) {
    New-Item -ItemType Directory -Path $sshPath
}
$filePath = Join-Path $sshPath $filename
ssh-keygen -t rsa -b 4096 -C "powershell_script" -f $filePath -P $passphrase

# Copy the public key to the specified server
$publicKey = Get-Content "$filePath.pub"
$sshPath = "/home/$(whoami)/.ssh"
ssh "$env:root@$serverIpAddress" "mkdir -p $sshPath && echo '$publicKey' >> $sshPath/authorized_keys"

Write-Host "SSH key pair created and public key copied to server."
