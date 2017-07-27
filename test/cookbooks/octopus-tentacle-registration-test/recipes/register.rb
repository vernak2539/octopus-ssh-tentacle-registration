OCTOPUS_DATA = node['octopus_ssh_tentacle_registration_test']

register_ssh_octopus_tenacle 'sample-server' do
  server_url OCTOPUS_DATA['server_url']
  api_key OCTOPUS_DATA['api_key']
  ssh_account_id OCTOPUS_DATA['ssh_account_id']
  environments OCTOPUS_DATA['environments']
  roles OCTOPUS_DATA['roles']
end
