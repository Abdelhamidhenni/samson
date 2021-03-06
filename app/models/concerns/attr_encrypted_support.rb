# frozen_string_literal: true
require 'attr_encrypted'

module AttrEncryptedSupport
  ENCRYPTION_KEY = Rails.application.secrets.secret_key_base[0...32]
  ENCRYPTION_KEY_SHA = Digest::SHA2.hexdigest(Rails.application.secrets.secret_key_base)

  def self.included(base)
    base.send :before_validation, :store_encryption_key_sha
    base.extend Defaults
  end

  private

  # store the key so we have the possibility of decrypting when rotating keys
  def store_encryption_key_sha
    self.encryption_key_sha = ENCRYPTION_KEY_SHA
  end

  # use the same defaults everywhere
  module Defaults
    def attr_encrypted(column)
      super(column, key: ENCRYPTION_KEY, algorithm: 'aes-256-cbc')
    end
  end
end
