# Provider # cert.rb

Puppet::Type.type(:sslcertificate).provide(:cert) do
  confine    osfamily: 'windows'
  defaultfor osfamily: 'windows'

  mk_resource_methods

  commands powershell:
               if File.exist?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
                 "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
               elsif File.exist?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
                 "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
               else
                 'powershell.exe'
               end

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def flush
    # flush the certificate into the system
    @property_hash = resource.to_hash
  end

  def exists?
    # does the certificate exist?
    @property_hash[:ensure] == :present
  end

  def self.write_cer_to_cert_file(certificate_content)
    # This creates a plaintext certificate file to be imported
    cert_file = 'c:/windows/temp/cert_file.cer'
    out_file = File.new(cert_file, 'w')
    out_file.puts(certificate_content.to_s)
    out_file.close
  end

  def self.write_base64_to_cert_file(format, certificate_content)
    # This converts the plaintext certificate content back to binary code.
    content = certificate_content.delete("\n").gsub(%r{/\s+/}, '')
    powershell("[IO.File]::WriteAllBytes('c:\\windows\\temp\\cert_file.#{format}', [Convert]::FromBase64String('#{content}'))")
  end

  def create
    # create a certiticate

    case resource[:format]
    when :cer
      # create .cer certificate
      self.class.write_cer_to_cert_file(resource[:certificate_content])
    when :crt
      # create .crt certificate
      self.class.write_base64_to_cert_file(resource[:format], resource[:certificate_content])
    when :pfx
      # create .pfx certificate
      self.class.write_base64_to_cert_file(resource[:format], resource[:certificate_content])
    end

    key_storage_flags = resource[:exportable] ? 'Exportable`,PersistKeySet' : 'PersistKeySet'

    self.class.run_import_certificate(resource[:format], resource[:password], key_storage_flags, resource[:name].split('\\')[1], resource[:name].split('\\')[2])

    # delete the temporary cert_file
    powershell("Remove-Item c:/windows/temp/cert_file.#{resource[:format]}")
  end

  def destroy
    # destroy a certificate
    @property_hash[:ensure] = :absent
    cert_name = @property_hash[:name]
    powershell("Remove-Item Cert:/#{cert_name} -DeleteKey")
  end

  # gets the property hash from the provider
  def to_hash
    instance_variable_get('@property_hash')
  end

  def self.instances
    instances        = []
    name             = ''
    path             = ''
    thumbprint       = ''
    subject          = ''
    issuer           = ''
    valid_from       = ''
    valid_till       = ''

    # read all certificates in the LocalMachine folder
    certificate_list = powershell("Get-ChildItem Cert:\LocalMachine -recurse | Format-list -Property pspath,subject,issuer,NotBefore,NotAfter | out-string -width 4096").gsub(%r{/^$\n/}, '')

    certificate_list.each_line do |line|
      var = line.delete("\n").split(':')

      case var[0]
      when 'PSPath    '
        if var[3]
          name       = var[3]
          path       = var[3]
          thumbprint = var[3].split('\\')[2]
        end
      when 'Subject   '
        subject    = var[1]
      when 'Issuer    '
        issuer     = var[1]
      when 'NotBefore '
        valid_from = line.split(' ')[2]
      when 'NotAfter  '
        valid_till = line.split(' ')[2]
        certificate_hash = {
          name: name,
          path: path,
          ensure: :present,
          thumbprint: thumbprint,
          issuer: issuer,
          subject: subject,
          valid_till: valid_till,
          valid_from: valid_from
        }
        inst = new(certificate_hash)
        instances << inst
      end
    end
    instances
  end

  def self.prefetch(resources)
    certificates = instances
    resources.keys.each do |name|
      if (provider = certificates.find { |certificate| certificate.name == name })
        resources[name].provider = provider
      end
    end
  end

  def self.run_import_certificate(format, password, key_storage_flags, store_dir, thumbprint)
    import_certificate = <<-IMPORT
  param (
    [string]$location = "c:/windows/temp",
    [string]$name = "cert_file.#{format}",
    [string]$password = "#{password}",
    [string]$key_storage_flags = "#{key_storage_flags}",
    [string]$store_dir = "#{store_dir}",
    [string]$root_store = "LocalMachine",
    [string]$thumbprint = "#{thumbprint}"
  )

  $certname = "$location/$name"
  $cert = gi $certname

  try {
    switch -regex ($cert.Extension.ToUpper()) {
      ".CER|.DER|.P12" {
        $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
        $pfx.Import("$certname","$password","$key_storage_flags")
      }
      ".CRT" {
        $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
        $pfx.Import([System.IO.File]::ReadAllBytes("$certname"))
      }
      ".P7B|.SST" {
        $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
        $pfx.Import([System.IO.File]::ReadAllBytes("$certname"))
      }
      ".PFX" {
        $pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
        $pfx.import("$certname","$password","$key_storage_flags")
      }
    }
  } catch {exit 13}

  $store = new-object System.Security.Cryptography.X509Certificates.X509Store("$store_dir","$root_store")
  $store.open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)

  $intermediatestore = new-object System.Security.Cryptography.X509Certificates.X509Store("CA","$root_store")
  $intermediatestore.open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)

  foreach($certif in $pfx) {
    if($certif.Thumbprint -ne "$thumbprint") {
      $intermediatestore.Add($certif)
    }
    else {
      $store.Add($certif)
    }
  }

  $store.close()
  IMPORT
    powershell([import_certificate])
  end
end
