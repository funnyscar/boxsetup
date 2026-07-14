Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "openclaw-dev"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.synced_folder ".", "/vagrant", disabled: false
  config.vm.provision "shell", path: "scripts/provision-openclaw.sh"
end
