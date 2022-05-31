# frozen_string_literal: true

require 'spec_helper'

type_class = Puppet::Type.type(:sslcertificate)

example = {
  name: 'LocalMachine\Store\670A1B2C3D4E5F89670A1B2C3D4E5F89ABCDEF89',
  ensure: :present,
  path: 'LocalMachine\Store\670A1B2C3D4E5F89670A1B2C3D4E5F89ABCDEF89',
  format: 'cer',
  password: 's@omeB1gSecr3t',
  certificate_content: 'MIIFyjCCA7KgAwIBAgIEAJiWjDANBgkqhkiG9w0BAQsFADBaMQswCQYDVQQGEwJOTDEeMBwGA1UE
          CgwVU3RhYXQgZGVyIE5lZGVybGFuZGVuMSswKQYDVQQDDCJTdGFhdCBkZXIgTmVkZXJsYW5kZW4g
          Um9vdCBDQSAtIEcyMB4XDTA4MDMyNjExMTgxN1oXDTIwMDMyNTExMDMxMFowWjELMAkGA1UEBhMC
          TkwxHjAcBgNVBAoMFVN0YWF0IGRlciBOZWRlcmxhbmRlbjErMCkGA1UEAwwiU3RhYXQgZGVyIE5l
          ZGVybGFuZGVuIFJvb3QgQ0EgLSBHMjCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMVZ
          5291qj5LnLW4rJ4L5PnZyqtdj7U5EILXr1HgO+EASGrP2uEGQxGZqhQlEq0i6ABtQ8SpuOUfiUtn
          vWFI7/3S4GCI5bkYYCjDdyutsDeqN95kWSpGV+RLufg3fNU254DBtvPUZ5uW6M7XxgpT0GtJlvOj
          CwV3SPcl5XCsMBQgJeN/dVrlSPhOewMHBPqCYYdu8DvEpMfQ9XQ+pV0aCPKbJdL2rAQmPlU6Yiil
          e7Iwr/g3wtG61jj99O9JMDeZJiFIhQGp5Rbn3JBV3w/oOM2ZNyFPXfUib2rFEhZgF1XyZWampzCR
          OME4HYYEhLoaJXhena/MUGDWE4dS7WMfbWV9whUYdMrhfmQpjHLYFhN9C0lK8SgbIHRrxT3dsKpI
          CT0ugpTNGmXZK4iambwYfp/ufWZ8Pr2UuIHOzZgweMFvZ9C+X+Bo7d7iscksWXiSqt8rYGPy5V65
          AAGjgZcwgZQwDwYDVR0TAQH/BAUwAwEB/zBSBgNVHSAESzBJMEcGBFUdIAAwPzA9BggrBgEFBQcC
          ARYxaHR0cDovL3d3dy5wa2lvdmVyaGVpZC5ubC9wb2xpY2llcy9yb290LXBvbGljeS1HMjAOBgNV
          HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFJFoMocVHYnitfGsNig0jQt8YojrMA0GCSqGSIb3DQEBCwUA
          A4ICAQCoQUpnKpKBglBu4dfYszk78wIVCVBR7y29JHuIhjv5tLySCZa59sCrI2AGeYwRTlHSeYAz
          +51IvuxBQ4EffkdAHOV6CMqqi3WtFMTC6GY8ggen5ieCWxjmD27ZUD6KQhgpxrRW/FYQoAUXvQwj
          f/ST7ZwaUb7dRUG/kSS0H4zpX897IZmflZ85OkYcbPnNe5yQzSipx6lVu6xiNGI1E0sUOlWDuYaN
          kqbG9AclVMwWVxJKgnjIFNkXgiYtXSAfea7+1HAWFpWD2DU5/1JddRwWxRNVz0fMdWVSSt7wsKfk
          CpYL+63C4iWEst3kvX5ZbJvw8NjnyvLplzh+ib7M+zkXYT9y2zqR2GUBGR2tUKRXCnxLvJxxcypF
          URmFzI79R6d0lR2o0a9OF7FpJsKqeFdbxU2n5Z4FF5TKsl+gSRiNNOkmbEgeqmiSBeGCc1qb3Adb
          CG19ndeNIdn8FCCqwkXfP+cAslHkwvgFuXkajDTznlvkN1trSt8sV4pAWja63XVECDdCcAz+3F4h
          oKOKwJCcaNpQ5kUQR3i2TtJlycM33+FCY7BXN0Ute4qcvwXqZVUz9zkQxSgqIXobisQk+T8VyJoV
          IPVVYpbtbZNQvOSqeK3Zywplh6ZmwcSBo3c6WB4L7oOLnR7SUqTMHW+wmG2UMbX4cQrcufx9MmDm
          66+KAQ==',
}

describe type_class do
  let :params do
    [
      :path,
    ]
  end

  let :properties do
    [
      :ensure,
      :format,
      :password,
      :certificate_content,
    ]
  end

  it 'has expected properties' do
    properties.each do |property|
      expect(type_class.properties.map(&:name)).to be_include(property)
    end
  end

  it 'has expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'requires a certificate_name' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  describe 'validate values' do
    it 'with  correct values' do
      expect {
        correct = example
        type_class.new(correct)
      }.not_to raise_error
    end
  end

  describe 'with incorrect values' do
    it 'with incorrect store in path' do
      expect {
        incorrect_store = example.clone
        incorrect_store[:path] = 'LocalMachine\\670A1B2C3D4E5F89670A1B2C3D4E5F89ABCDEF89'
        type_class.new(incorrect_store)
      }.to raise_error(Puppet::ResourceError, %r{LocalMachine\\<store_dir>\\<thumbprint>})
    end

    it 'with incorrect thumbprint in path' do
      expect {
        incorrect_thumbprint = example.clone
        incorrect_thumbprint[:path] = 'LocalMachine\Is a store\ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'
        type_class.new(incorrect_thumbprint)
      }.to raise_error(Puppet::ResourceError, %r{thumbprint of 40 hexadecimal numbers})
    end

    it 'with incorrect format' do
      expect {
        incorrect_format = example.clone
        incorrect_format[:format] = 'cmd'
        type_class.new(incorrect_format)
      }.to raise_error(Puppet::ResourceError, %r{Valid values are cer, crt, pfx})
    end
  end
end
