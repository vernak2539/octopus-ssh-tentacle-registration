module OcotopusDeploy
  module SshTentacleRegistration
    def display_name
      'Octopus Deploy SSH Tentacle Registration'
    end

    def machine_id_file_location
      '/opt/octopus/machine_id'
    end

    def tentacle_already_registered(machine_id_file)
      return ::File.exist?(machine_id_file)
    end

    def tentacle_machine_id(machine_id_file)
      return unless ::File.exist?(machine_id_file)

      matcher = ::File.open(machine_id_file, &:readline)
      return matcher if matcher
    end

    def generateFingerPrint()
      Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
      command = 'ssh-keygen -E md5 -lf /etc/ssh/ssh_host_rsa_key.pub | cut -d\' \' -f2 | awk \'{ print $1}\' | cut -d\':\' -f2-'
      command_out = shell_out(command)
      return command_out.stdout.strip
    end

    def register_machine(params)
      post_data = {
        Endpoint: {
          CommunicationStyle: 'Ssh',
          AccountId: params[:ssh_account_id],
          Host: params[:node][:ipaddress],
          Port: 22,
          Fingerprint: params[:fingerprint].strip,
          DotNetCorePlatform: params[:dotnet_core_platform]
        },
        EnvironmentIds: params[:environments],
        Name: params[:node][:machinename].upcase,
        Roles: params[:roles],
      }

      uri = URI.parse(params[:url])
      http = Net::HTTP.new(uri.host, uri.port)
      if(uri.port == 443)
        http.use_ssl = true
      end
      response = http.post('/api/machines', post_data.to_json, 'X-Octopus-ApiKey' => params[:api_key], 'Content-Type' => 'application/json')

      registered_machine = JSON.parse(response.body)

      return {
        id: registered_machine['Id'],
        post_data: post_data.to_json,
        response: registered_machine
      }
    end
  end
end
