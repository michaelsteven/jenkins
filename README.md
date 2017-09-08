# Atomic Jenkins OVA Build using Packer

### Example build script
~~~
# variables
branchName="CHANGE_ME"
buildNumber="CHANGE_ME"
esxiHost="CHANGE_ME"
esxiDatastore="CHANGE_ME"
esxiPassword="CHANGE_ME"

buildName="${branchName}-${buildNumber}"
vmName="fedora-atomic_${branchName}"
buildShare="/mnt/Builds/fedora-atomic/${branchName}/"
buildDir="${buildShare}${buildName}"

mkdir -p "${buildShare}/${buildName}"
PACKER_LOG=1 packer build -var "output_dir=${buildShare}/${buildName}" -var "build_name=${buildName}" -var "vm_name=${vmName}" -var "esxi_host=${esxiHost}" -var "esxi_password=${esxiPassword}" -var "esxi_datastore=${esxiDatastore}" packer/template-fedora-atomic.json
mv "${vmName}/${vmName}.ova/${vmName}.ova" "${buildDir}/${buildName}.ova"

~~~
