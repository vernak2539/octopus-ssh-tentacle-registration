require 'spec_helper'
require_relative '../../libraries/regstration'

describe 'OcotopusDeploy::SshTentacleRegistration' do
  let(:registration) { Class.new { include OcotopusDeploy::SshTentacleRegistration }.new }

  describe 'display_name' do
    it 'should return the correct display name' do
      expect(registration.display_name).to eq 'Octopus Deploy SSH Tentacle Registration'
    end
  end

  describe 'path to store machine id after registration' do
    it 'should return the file path' do
      expect(registration.machine_id_file_location).to eq '/opt/octopus/machine_id'
    end
  end

  describe 'if tentacle has already been registered' do
    it 'should return true if machine is already registered' do
      allow(::File).to receive(:exist?).with('file').and_return(true)

      expect(registration.tentacle_already_registered('file')).to eq true
    end

    it 'should return false if machine is already registered' do
      allow(::File).to receive(:exist?).with('file').and_return(false)

      expect(registration.tentacle_already_registered('file')).to eq false
    end
  end

  describe 'reading machine id from file' do
    it 'should return nil if the file does not exist' do
      allow(::File).to receive(:exist?).with('file').and_return(false)

      expect(registration.tentacle_machine_id('file')).to eq nil
    end

    it 'should return the machine id if the file exists' do
      MACHINE_ID = 'MachineID-21324'
      SAMPLE_FILE = 'file'
      allow(::File).to receive(:exist?).with(SAMPLE_FILE).and_return(true)
      allow(::File).to receive(:open).with(SAMPLE_FILE).and_return(MACHINE_ID)

      expect(registration.tentacle_machine_id(SAMPLE_FILE)).to eq MACHINE_ID
    end
  end

  describe 'resending request to octopus api' do
    it 'should return machine id if response is correct' do
      SAMPLE_ID = 123456;
      sample_url = 'sample.url.test.com'

      stub_request(:post, "#{sample_url}/api/machines").to_return(body: { Id: SAMPLE_ID }.to_json)

      params = {
        url: sample_url,
        ssh_account_id: '1',
        fingerprint: 'fingerprint here',
        roles: ['role1'],
        environments: ['envrionment_id'],
        node: {
          ipaddress: '127.0.0.1',
          machinename: 'machine.name'
        },
        api_key: 'API-XXXXXXXXXX'
      }
      expect(registration.register_machine(params)).to eq SAMPLE_ID
    end
  end
end
