register_ssh_octopus_tenacle 'sample-server' do
  server_url 'https://octopus.deploy.io'
  api_key 'API-XXXXXXXXXXXXXXXXXXXX'
  ssh_account_id 'ssh-id'
  environments ['Environments-100']
  roles ['qa']
end
