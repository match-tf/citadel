class HeroimageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/banners/#{model.id}"
  end

  def default_url
    path = 'fallback/' + [version_name, 'heroimage_default.png'].compact.join('_')

    ActionController::Base.helpers.asset_path path
  end


  process resize_to_fit: [1500, 300]

  version :thumb do
    process resize_to_fill: [500, 100]
  end

  def extension_white_list
    %w[jpg jpeg png]
  end

  def content_type_whitelist
    %r{image\/}
  end
end