# chord scripts

Install scripts for `chord_singularity` on Ubuntu 18.04 LTS

Start off by installing needed packages, certbot, and keycloak:

`sudo ./install_chord.sh`

Edit the file `config.sh` to have the values of users, passwords, etc that
are required.

Now configure keycloak - you'll need the output of this set for setting up the authentication config.

` sudo ./setup_keycloak.sh > keycloak.out`

Setup certbot by answering the prompts:

`sudo certbot certonly --nginx`

With that set up we can start nginx up and running, first by generating the config file,
then by copying it into place and starting the service:

```
./untemplate_confs.sh
sudo cp nginx.conf /etc/nginx/nginx.conf
sudo systemctl start nginx
```

If you visit `http://${FULLHOST}` now you should see the nginx welcome page.

Edit `${CHORD_DATA_PATH}/.auth_config.json` to include the client secret
and owner ID from keycloak out, and you should now be able to start the singularity container:

`./start_singularity.sh`

And restart nginx:

`sudo systemctl restart nginx`
