class NewsimageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [1600, 800]

  version :thumb do
    process resize_to_fill: [512, 256]
  end

  def extension_white_list
    %w[jpg jpeg png]
  end

  def content_type_whitelist
    %r{image\/}
  end
end