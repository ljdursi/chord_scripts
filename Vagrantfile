Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-19.10"

  config.vm.network :forwarded_port, guest: 8080, host: 8180, auto_correct: true

  config.vm.synced_folder "./", "/var/host"

  config.vm.provision "shell", path: "install_chord.sh"

  config.vm.provider :virtualbox do |v|
    v.name = "CHORD Singularity"
    v.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2"]
  end
end
