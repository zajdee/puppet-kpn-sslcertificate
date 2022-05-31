# frozen_string_literal: true

require 'spec_helper'

provider_resource = Puppet::Type.type(:sslcertificate)
provider_class    = provider_resource.provider(:cert)

describe provider_class do
  subject { provider_class }

  let(:resource) do
    provider_resource.new(
      name: 'any_certificate',
      ensure: 'present',
      path: 'LocalMachine\\Store\\670A1B2C3D4E5F89670A1B2C3D4E5F89ABCDEF89',
      format: 'cer',
      password: 's@omeB1gSecr3t',
      certificate_content: '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
              66+KAQ==',
    )
  end
  let(:provider) { described_class.new(resource) }

  describe 'provider' do
    it 'is an instance of Puppet::Type::Sslcertificate::ProviderCert' do
      expect(provider).to be_an_instance_of Puppet::Type::Sslcertificate::ProviderCert
    end

    it 'responds to function calls' do
      expect(provider).to respond_to(:path)
      expect(provider).to respond_to(:ensure)
      expect(provider).to respond_to(:flush)
      expect(provider.class).to respond_to(:instances)
      expect(provider.class).to respond_to(:prefetch)
    end

    describe 'instances' do
      it 'returns certificate properties' do
        sslcertifs = "PSPath    : Microsoft.PowerShell.Security\\Certificate::LocalMachine\\Root\\CDD4EEAE6000AC7F40C3802C171E30148030C072\n
Subject   : CN=Microsoft Root Certificate Authority, DC=microsoft, DC=com\n
Issuer    : CN=Microsoft Root Certificate Authority, DC=microsoft, DC=com\n
NotBefore : 5/10/2001 1:19:22 AM\n
NotAfter  : 5/10/2021 1:28:13 AM\n"

        provider.class.stubs(powershell: sslcertifs)
        provider.class.expects(:new)
                .with(
                  name: 'LocalMachine\\Root\\CDD4EEAE6000AC7F40C3802C171E30148030C072',
                  path: 'LocalMachine\\Root\\CDD4EEAE6000AC7F40C3802C171E30148030C072',
                  ensure: :present,
                  thumbprint: 'CDD4EEAE6000AC7F40C3802C171E30148030C072',
                  issuer: ' CN=Microsoft Root Certificate Authority, DC=microsoft, DC=com',
                  subject: ' CN=Microsoft Root Certificate Authority, DC=microsoft, DC=com',
                  valid_from: '5/10/2001',
                  valid_till: '5/10/2021',
                )
        provider.class.instances
      end
    end

    describe 'self.' do
      describe 'prefetch' do
        context 'with valid resource' do
          it 'stores prov into resource.provider' do
            prov_mock = mock
            prov_mock.expects(:name).returns('foo')
            resource_mock = mock
            resource_mock.expects(:provider=)
            resources = {}
            resources['foo'] = resource_mock
            provider.class.stubs(instances: [prov_mock])
            provider.class.prefetch(resources)
          end
        end
      end
    end
  end
end
