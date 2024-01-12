# Define variables
$vagrantFilePath = "C:\ProgramData\Jenkins\.jenkins\workspace\myfirstjob\vsphere\zf_san\Vagrantfile"

# Navigate to the directory containing the Vagrantfile
Set-Location -Path (Get-Item $vagrantFilePath).DirectoryName

# Check if Vagrant is installed
if (-not (Get-Command vagrant -ErrorAction SilentlyContinue)) {
    Write-Host "Vagrant is not installed. Please install Vagrant before running this script."
    exit 1
}

# Ensure the Vagrant VM is not running
if (vagrant global-status --prune) {
    vagrant halt
}

# Bring up the Vagrant VM
vagrant up

# Display status after VM deployment
vagrant status
