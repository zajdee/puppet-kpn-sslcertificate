# frozen_string_literal: true

# Type # sslcertificate.rb
Puppet::Type.newtype(:sslcertificate) do
  desc 'Puppet type that manages Windows certificates'

  ensurable

  desc 'sslcertificate type for windows'

  newparam(:path, namevar: true) do
    desc 'Certificate name - This can be any name but must be unique'
    validate do |value|
      raise 'The path should contain LocalMachine\\<store_dir>\\<thumbprint>' unless value =~ %r{^LocalMachine\\[a-zA-Z\s]*\\[a=zA-Z0-9]*}
      raise 'The path should end with a thumbprint of 40 hexadecimal numbers (uppercase)' unless value =~ %r{\\([A-F0-9]{40})$}
    end
  end

  newproperty(:format) do
    desc 'The certificate format - This is only used to create a certificate and is therefore not added to the certificate properties'
    newvalues('cer', 'crt', 'pfx', 'pem')
    def insync?(_is)
      true
    end
  end

  newproperty(:certificate_content) do
    desc 'The certificate content - This is only used to create a certificate and is therefore  not added to the certificate properties'
    validate do |value|
    end
    munge do |value|
      value.gsub('  ', '')
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:password) do
    desc 'The certificate password - This is only used to create a certificate and is therefore not added to the certificate properties'
    defaultto 'dummy'
    validate do |value|
      raise 'Password should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:exportable) do
    desc 'Exportable sets if a key can be exported. This value is only used to create a certificate and is therefore not added to the certificate properties'
    newvalues(true, false)
    defaultto true
    def insync?(_is)
      true
    end
  end

  newproperty(:thumbprint) do
    desc 'The thumbprint - This is part of the certificate name and is therefore a read-only parameter'
    validate do |value|
      raise 'thumbprint should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:subject) do
    desc 'The subject value - This is a read-only parameter'
    validate do |value|
      raise 'thumbprint should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:issuer) do
    desc 'The issuer value - This is a read-only parameter'
    validate do |value|
      raise 'thumbprint should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:valid_from) do
    desc 'The valid_from value - This is a read-only parameter'
    validate do |value|
      raise 'valid_from should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end

  newproperty(:valid_till) do
    desc 'The valid_till value - This is a read-only parameter'
    validate do |value|
      raise 'valid_till should be a String' unless value.is_a? String
    end
    def insync?(_is)
      true
    end
  end
end
