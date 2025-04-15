module EncryptionHelper
  require 'openssl'
  require 'base64'

  def self.encrypt(data)
    raise ArgumentError, "Data must not be empty" if data.blank?

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = [ENV['ENCRYPTION_KEY']].pack('H*') # Convert hex string to binary
    cipher.iv = [ENV['ENCRYPTION_IV']].pack('H*')   # Convert hex string to binary
    encrypted = cipher.update(data) + cipher.final
    Base64.encode64(encrypted)
  end

  def self.decrypt(data)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.decrypt
    cipher.key = [ENV['ENCRYPTION_KEY']].pack('H*') # Convert hex string to binary
    cipher.iv = [ENV['ENCRYPTION_IV']].pack('H*')   # Convert hex string to binary
    decrypted = cipher.update(Base64.decode64(data)) + cipher.final
    decrypted
  end
end