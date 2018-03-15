require 'spec_helper_acceptance'

describe 'sslcertificate', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  context 'with installing 2 certificates' do
    it 'works idempotently with no errors' do
      pp = <<-CERT
      # Create certificates

      sslcertificate { 'certificaat_cer':
        path            => 'LocalMachine\\CA\\4EB251A8CA19975AE959E26D41F12A82B9DE761B',
        ensure          => 'present',
        format          => 'cer',
        certificate_content => '-----BEGIN CERTIFICATE-----
          MIIGzzCCBLegAwIBAgIEATE3FzANBgkqhkiG9w0BAQsFADBhMQswCQYDVQQGEwJO
          TDEeMBwGA1UECgwVU3RhYXQgZGVyIE5lZGVybGFuZGVuMTIwMAYDVQQDDClTdGFh
          dCBkZXIgTmVkZXJsYW5kZW4gT3JnYW5pc2F0aWUgQ0EgLSBHMjAeFw0xMjAyMDgx
          MDU2MzlaFw0yMDAzMjMxMDUzMDVaMGYxCzAJBgNVBAYTAk5MMSAwHgYDVQQKDBdL
          UE4gQ29ycG9yYXRlIE1hcmtldCBCVjE1MDMGA1UEAwwsS1BOIENvcnBvcmF0ZSBN
          YXJrZXQgQ1NQIE9yZ2FuaXNhdGllIENBIC0gRzIwggIiMA0GCSqGSIb3DQEBAQUA
          A4ICDwAwggIKAoICAQDPaXEQLwUn+rPvWFLOqPcEOQ3kwr/gaIXtOeulL11iWvvo
          ovEj8FQY2pHm4qISNjQcSF86aNzIGn84hbsCDmJ8VeeoUAOhUaCwn38kquDSCaeQ
          kQjZOLbBt4len4PpxzMxcv+kww7JRjEQCuzBswBPjrLHJQXnWDTmak36oEyGXeku
          Y3EVQGaRWS5eLJEFireJ8ABWmVKNOf2q+p9DZIhU2KefmKmeED9icW8sUMy9Mfpz
          B8lFPm+xqlsIm0LbGTuzN6g5fNgy+73PiME6qnYDkmXeZ3+qDpn/pTGHj986cR7Z
          /dgPkADVTzhhPOgUSaUW2/AEgOMPJyOmw5YpxgjxkIdcnvzgQc3y3zqj56vGx7Sa
          aIL43HsQIrr1TgLyOorOmtodBiobGFcswtRg66lSyfkiF7Z4EuPQ4BqUwm5ZFjyt
          xLtMvKTEtFFMDMBZHUkiBOfyOaTEA5Bmbn0p6DyGNMu1a4MgDun7hxtG74Ao8DDe
          s4A4noD6nT75Vp+M/SrMHubK1qctTGgY1C8q97/5pdprs22xTRXUdoM3dg2Ps16A
          0oInAWeXzErN6/mI+morPgifglyGr2bBtVT8XRtHhTeXlBFwgEcxkgxDDNTA8ZdT
          ftkwRmMOCna3I5gQUqvHi33Rl7Bbe1dnTqZFf2Hibf8LQMqQG9pDX5+JLmWwUQID
          AQABo4IBiDCCAYQwSwYDVR0gBEQwQjBABgRVHSAAMDgwNgYIKwYBBQUHAgEWKmh0
          dHA6Ly9jZXJ0aWZpY2FhdC5rcG4uY29tL3BraW92ZXJoZWlkL2NwczAPBgNVHRMB
          Af8EBTADAQH/MCIGA1UdEQQbMBmkFzAVMRMwEQYDVQQDDApwcnY0MDk2LTExMA4G
          A1UdDwEB/wQEAwIBBjCBhQYDVR0jBH4wfIAUORCLSZJc22ESIM1JnRqO2pxnQLmh
          XqRcMFoxCzAJBgNVBAYTAk5MMR4wHAYDVQQKDBVTdGFhdCBkZXIgTmVkZXJsYW5k
          ZW4xKzApBgNVBAMMIlN0YWF0IGRlciBOZWRlcmxhbmRlbiBSb290IENBIC0gRzKC
          BACYlvQwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5wa2lvdmVyaGVpZC5u
          bC9Eb21PcmdhbmlzYXRpZUxhdGVzdENSTC1HMi5jcmwwHQYDVR0OBBYEFCbQZRPx
          7npvYQgo3k2YBxJIeLTvMA0GCSqGSIb3DQEBCwUAA4ICAQCNqeixijV4hAjsSWCp
          107vHt/ItR8V8nJ6xrRtsvnO/M29xA3PYMwCO/SZRT+LsS0D/K9ZKVxA0XP020k7
          GgOR4nQiqH19+922lOFUiDrkabNyY7IpBZAdJWnSdTrvAnGPt6OnK9gP43Ndn5QI
          XIAdWRv0FVRm1MhdA3TGSp8EQZTnD6BzUQdB7fK8SFo/n6rKVR+Rl+xvpTNCXh1z
          Tjd17t4L30d7D3OGtvNPhCsmf2zz9D1lAq4C0yuAYxn9w1hqrD3MyqdimmRLuzWb
          ejkB6QA+v4qzlHk+clOyHFyNJ9BUc70kmv9AWM4DLYX5cUGgMiJObh07DjGQrcRo
          q4GbaS07k1FDVCgQ3AR4BrMW3HSxUYnq9wyLV28bbfAv0P2Bb8QfhMz8jazaTfQJ
          QdMGFb4WAhdmH598DU3BZ07Ly1agZRefj43ylnTA4BWi4gxgXLdziL5ufaQTGB9W
          IPE/QBTIVN6e7ksjW30uJn3vKHFrQn48c/y8i2uJhRDxqn3A81bou06vJ6rNVX+S
          6lYAkxlf0cjZA8KmdhI69JWw/WxpRbyN8t3eHWq9+PEJ1bh6/nmQ47ycjbckRG8e
          XHpiIw4GzrOv7zZrpZ2Y5Roi86cJyrsaAENr69NZ56Heqamsv4jvyJMVOUyWw+qb
          l409YpY9zs9PyeP2WLK3rIH3hQ==
          -----END CERTIFICATE-----',
      }
      sslcertificate { 'certificaat_crt':
        path            => 'LocalMachine\\Root\\59AF82799186C7B47507CBCF035746EB04DDB716',
        ensure          => 'present',
        format          => 'crt',
        certificate_content => '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
          66+KAQ==',
      }
      CERT

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\CA\4EB251A8CA19975AE959E26D41F12A82B9DE761B).thumbprint"') do
      its(:stdout) { is_expected.to match %r{4EB251A8CA19975AE959E26D41F12A82B9DE761B} }
    end

    describe command('powershell.exe "(Get-ChildItem Cert:\LocalMachine\Root\59AF82799186C7B47507CBCF035746EB04DDB716).thumbprint"') do
      its(:stdout) { is_expected.to match %r{59AF82799186C7B47507CBCF035746EB04DDB716} }
    end
  end
end
