# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'sslcertificate', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  context 'with removimg 2 certificates' do
    it 'works idempotently with no errors' do
      pp = <<-CERT
      # Destroy certificates

      sslcertificate { 'certificaat_crt':
        path            => 'LocalMachine\\Root\\59AF82799186C7B47507CBCF035746EB04DDB716',
        ensure          => 'absent',
      }
      sslcertificate { 'certificaat_cer':
        path            => 'LocalMachine\\CA\\4EB251A8CA19975AE959E26D41F12A82B9DE761B',
        ensure          => 'absent',
      }
      CERT
      # Run it twice and test for idempotency
      if fact('operatingsystemmajrelease') =~ %r{/2008/}
        apply_manifest(pp, catch_failures: true)
      end
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\Root\59AF82799186C7B47507CBCF035746EB04DDB716).thumbprint"') do
      its(:stdout) { is_expected.to match %r{} }
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\CA\4EB251A8CA19975AE959E26D41F12A82B9DE761B).thumbprint"') do
      its(:stdout) { is_expected.to match %r{} }
    end
  end
end
