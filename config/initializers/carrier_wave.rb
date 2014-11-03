if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Google Cloud Storage
      # Instructions at http://fog.io/storage/
      :provider              => 'Google',
      :google_storage_access_key_id     => ENV['GCS_ACCESS_KEY'],
      :google_storage_secret_access_key => ENV['GCS_SECRET_KEY']
    }
    config.fog_directory     =  ENV['GCS_BUCKET']
  end
end